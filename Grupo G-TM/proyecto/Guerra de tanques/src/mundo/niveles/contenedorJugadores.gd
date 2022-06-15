extends Spatial


signal aparece_jugador
var puntos_de_spawn = []
var Contador_jugadores = 0

func _ready():
	for child in get_children():
		puntos_de_spawn.append(child.translation)
	while(self.get_child_count()>0):
		self.remove_child(self.get_child(0))
	self.connect("aparece_jugador", Network, "_jugador_nace")




var nombres_jugadores_odenados = []

remote func ordenar_jugadores():
	nombres_jugadores_odenados = []
	for child in get_children():
		if child.is_in_group("player"):
			nombres_jugadores_odenados.push_back(child.name)
	nombres_jugadores_odenados.sort_custom(self,"_posComparaison")

func _posComparaison(nameA,nameB):
	return (get_node(nameA) as Spatial).translation.z < get_node(nameB).translation.z


func _configurar_jugadores():
	for playerIdx in Network.jugador:
		addPlayer(playerIdx)
	emit_signal("aparece_jugador")

remote func addPlayer(playerIdx):
	print("jugador :", playerIdx," dic : ", Network.jugador[playerIdx])
	var agregar = load(Gamestate.informacion_del_jugador.tanque).instance()
	agregar.id = Network.jugador[playerIdx].net_id
	agregar.name = "Jugador" + str(Network.jugador[playerIdx].net_id)
	self.add_child(agregar)
	agregar.master_translation = puntos_de_spawn[Contador_jugadores]
	agregar.translation = puntos_de_spawn[Contador_jugadores]
	agregar.connect("muerte",self,"trae_camara_muerta")
	print(agregar.translation)
	Contador_jugadores += 1
	Actualiza_camara()

remote func Actualiza_camara():
	for child in get_children():
		if child.is_in_group("player"):
			child.Actualiza_camara()

remote func trae_camara_muerta(id):
	if id == Gamestate.informacion_del_jugador.net_id:
		get_parent().get_node("Camera").current = true
		get_parent().get_node("Camera/btnAparecer").disabled = false
		get_parent().get_node("Camera/btnAparecer").visible = true
		get_parent().get_node("Camera/btnSalir").disabled = false
		get_parent().get_node("Camera/btnSalir").visible = true


func actualizar_nuevo_jugador(net_id):
	var agregar = []
	for child in get_children():
		agregar.append({"filename" : child.filename, "nombre" : child.name})
	rpc_id(net_id, "bienvenida", agregar)



remote func bienvenida(toAddArray):
	for toAddDict in toAddArray:
		if not self.has_node(toAddDict.name):
			var agregar = load(toAddDict.filename).instance()
			agregar.name  = toAddDict.name
			self.add_child(agregar)







