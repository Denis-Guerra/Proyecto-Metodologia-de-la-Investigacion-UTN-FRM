extends Control



func _ready():
	if Gamestate.informacion_del_jugador.net_id != 1:
		botones_desactivados()

func botones_desactivados():
	$Panel/seleccionNivel.disabled = true
	$Panel/levelDisplayer/Siguiente.disabled = true
	$Panel/levelDisplayer/Anterior.disabled = true

func _on_StartGame_pressed():
	if Gamestate.informacion_del_jugador.net_id == 1:
		Network.coordinacion_inicio_juego($Panel/levelDisplayer.cargar)


func actualizar_nuevo_jugador(id):
	print(self," welcoming ",id)
	$Panel/levelDisplayer.actualizar_nuevo_jugador(id)
