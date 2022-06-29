extends Control



func _ready():
	Network.connect("lista_de_jugadores_cambio",self, "actualizar_lista_de_jugadores")
	actualizar_lista_de_jugadores()

func actualizar_lista_de_jugadores():
	while get_child_count() > 0:
		self.remove_child(self.get_child(0))
	for playerIdx in Network.jugador:
		var agregar = Label.new()
		agregar.text = Network.jugador[playerIdx].name
		self.add_child(agregar)
