extends Spatial



signal aparece_jugador
var puntos_de_spawn = []
var Contador_jugadores = 0

func _ready():
	for child in get_children():
		puntos_de_spawn.append(child.translation)
	while(self.get_child_count()>0):
		self.remove_child(self.get_child(0))
	self.connect("aparece_jugador", Network, "_player_spawned")




var nombresDeJugadoresOrdenados = []

remote func ordenar_jugador():
	nombresDeJugadoresOrdenados = []
	for child in get_children():
		if child.is_in_group("player"):
			nombresDeJugadoresOrdenados.push_back(child.name)
	nombresDeJugadoresOrdenados.sort_custom(self,"_posComparaison")


func _posComparaison(nameA,nameB):
	return (get_node(nameA) as Spatial).translation.z < get_node(nameB).translation.z


func _instanciar_jugadores():
	for playerIdx in Network.players:
		addPlayer(playerIdx)
	emit_signal("aparece_jugador")

remote func addPlayer(playerIdx):
	print("addPlayer :", playerIdx," dic : ", Network.players[playerIdx])
	var agregar = load("res://src/mundo/jugador/tanque.tscn").instance()
	agregar.id = Network.players[playerIdx].net_id
	agregar.name = "Player" + str(Network.players[playerIdx].net_id)
	self.add_child(agregar)
	agregar.master_translation = puntos_de_spawn[Contador_jugadores]
	agregar.translation = puntos_de_spawn[Contador_jugadores]
	agregar.connect("muerte",self,"trae_camara_muerta")
	print(agregar.translation)
	Contador_jugadores += 1
	Actualiza_camara()
	Puntos_Spawn()

remote func Actualiza_camara():
	for child in get_children():
		if child.is_in_group("player"):
			child.Actualiza_camara()

remote func trae_camara_muerta(id):
	if id == Gamestate.informacion_del_jugador.net_id:
		get_parent().get_node("Camara").current = true
		get_parent().get_node("camara/btnAparecer").disabled = false
		get_parent().get_node("camara/btnAparecer").visible = true


func actualizar_nuevo_jugador(net_id):
	var agregar = []
	for child in get_children():
		agregar.append({"filename" : child.filename, "name" : child.name})
	rpc_id(net_id, "bienvenida", agregar)



remote func bienvenida(toAddArray):
	for toAddDict in toAddArray:
		if not self.has_node(toAddDict.name):
			var agregar = load(toAddDict.filename).instance()
			agregar.name  = toAddDict.name
			self.add_child(agregar)

func Puntos_Spawn():
	if Contador_jugadores == 3:
		Contador_jugadores=0
