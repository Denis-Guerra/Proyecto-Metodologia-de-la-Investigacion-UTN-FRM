extends Node

signal creacion_de_server                          
signal conexion_lista                            
signal conexion_fallida                               
signal lista_de_jugadores_cambio                    
signal jugador_Desconectado                          




var info_servidor = {
	name = "Server",           # nombre servidor
	maximo_jugadores = 4,      # maximo jugadores
	puerto_usado = 28960       # puerto
}

var actualNet
var jugador = {}
var enUnServidor = false
var posicion_tp = Vector3(63,0,67)


func _ready():
	get_tree().connect("network_peer_connected", self, "_jugador_se_conecta")
	get_tree().connect("network_peer_disconnected", self, "_jugador_se_desconecta")
	get_tree().connect("connected_to_server", self, "_conectado_en_el_servidor")
	get_tree().connect("connection_failed", self, "_conexion_fallida")
	get_tree().connect("server_disconnected", self, "_desconexion_server")




func _jugador_se_conecta(id):
	print(id)




func _jugador_se_desconecta(id):
	print("jugador ", jugador[id].name, " desconectado del servidor ")
	
	if (get_tree().is_network_server()):
		
		sacar_jugador(id)
		
		rpc("sacar_jugador", id)
		
		emit_signal("jugador_Desconectado",id)



func _conectado_en_el_servidor():
	rpc_id(1,"servidor_cordina_jugadores_registrados",Gamestate.informacion_del_jugador)
	emit_signal("conexion_lista")
	enUnServidor = true
	print("conectado ",Gamestate.informacion_del_jugador)






func _conexion_fallida():
	emit_signal("conexion_fallida")
	get_tree().set_network_peer(null)
	print("conexion fallida")



func _desconexion_server():
	get_tree().set_network_peer(null)
	get_tree().change_scene("res://src/UI/serverDisconnected.tscn")
	


func _host_iniciado():
	print("iniciado el host")




func create_server():
	
	var red = NetworkedMultiplayerENet.new()
	
	
	var server_creation_info = red.create_server(info_servidor.puerto_usado, info_servidor.maximo_jugadores)
	
	if (server_creation_info != OK):
		print("fallo la creacion del server, ",server_creation_info)
		return
	
	
	get_tree().set_network_peer(red)
	registro_jugador(Gamestate.informacion_del_jugador)
	emit_signal("creacion_de_server")
	print("servidor creadoooo")


func unirse_a_servidor(ip):
	var red = NetworkedMultiplayerENet.new()
	
	if (red.create_client(ip, int(info_servidor.puerto_usado)) != OK):
		print("fallo la creacion del server")
		emit_signal("conexion_fallida")
		return false
	print("creado el cliente")
	get_tree().set_network_peer(red)
	Gamestate.informacion_del_jugador.net_id = red.get_unique_id()
	return true



remote func cambio_Escena(toWhat):
	if get_tree().current_scene.filename != toWhat:
		get_tree().change_scene(toWhat)
		rpc_id(1, "listo_para_dar_bienvenida", Gamestate.informacion_del_jugador.net_id)

remote func listo_para_dar_bienvenida(id):
	print(get_tree().current_scene.name)
	if get_tree().current_scene.is_in_group("wellcoming"):
		get_tree().current_scene.actualizar_nuevo_jugador(id)

remote func servidor_cordina_jugadores_registrados(pinfo):
	if Gamestate.informacion_del_jugador.net_id == 1:
		rpc_id(pinfo.net_id, "cambio_Escena", get_tree().current_scene.filename)
		for playerIdx in jugador:
			rpc_id(pinfo.net_id, "registro_jugador", jugador[playerIdx])
		rpc("registro_jugador",pinfo)
		registro_jugador(pinfo)


remote func registro_jugador(pInfo):
	jugador[pInfo.net_id] = pInfo
	emit_signal("lista_de_jugadores_cambio")
	print(jugador)

remote func sacar_jugador(id):
	print("removiendo jugador ", jugador[id].name, "")
	
	jugador.erase(id)
	
	emit_signal("lista_de_jugadores_cambio")

func actualizar_jugador(net_id, key, new_value):
	(jugador[net_id] as Dictionary)[key] = new_value


func mapa_selecionado():
	rpc("seleccion_mapa")
	seleccion_mapa()


remote func seleccion_mapa():
	get_tree().change_scene("res://src/UI/playerLevelSelection.tscn")

func coordinacion_inicio_juego(cargar):
	rpc("inicio_juego",cargar)
	inicio_juego(cargar)


remote func inicio_juego(cargar):
	var EscenaCargada = load(cargar)
	get_tree().change_scene_to(EscenaCargada)


remote func jugador_listo(net_id):
	actualizar_jugador(net_id, "ready_to_start_game", true)
	for playerNetId in jugador:
		if !jugador[playerNetId].ready_to_start_game:
			return
	coordina_camara_corriente()

func _jugador_nace():
	if Gamestate.informacion_del_jugador.net_id == 1:
		jugador_listo(1)
	else:
		rpc_id(1,"jugador_listo",Gamestate.informacion_del_jugador.net_id)

func coordina_camara_corriente():
	get_node("/root").print_tree_pretty()
	get_node("/root/world/playersContainer").rpc("Actualiza_camara")
	get_node("/root/world/playersContainer").Actualiza_camara()


func _jugador_a_muerto(playerId):
	if playerId == Gamestate.informacion_del_jugador.net_id:
		print("eh muerto")
	else:
		if jugador.has(playerId):
			print(jugador[playerId].name +str(" muerto."))
		else:
			print("blank.")

func server_coordinate_receive_boost(id,toReceive):
	if recibe_boost(id,toReceive):
		rpc("recibe_boost",id,toReceive)
	print(jugador)

remote func recibe_boost(id,toReceive):
	if jugador[id].bonuses.has(toReceive):
		return false
	(jugador[id].bonuses as Array).append(toReceive)
	return true


