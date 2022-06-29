extends Control



func _ready():
	if Gamestate.informacion_del_jugador.net_id != 1:
		botones_desactivados()

func botones_desactivados():
	$Panel/levelDisplayer/Siguiente.disabled = true
	$Panel/levelDisplayer/Anterior.disabled = true
	$Panel/IniciaPartida.disabled = true

func _on_StartGame_pressed():
	if Gamestate.informacion_del_jugador.net_id == 1:
		Network.coordinacion_inicio_juego($Panel/levelDisplayer.cargar)


func actualizar_nuevo_jugador(id):
	print(self," welcoming ",id)
	$Panel/levelDisplayer.actualizar_nuevo_jugador(id)


func _on_IniciaPartida_button_down():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click2").play()


func _on_IniciaPartida_mouse_entered():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click").play()
	
	


func _on_Siguiente_button_down():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click2").play()




func _on_Siguiente_mouse_entered():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click").play()
	


func _on_Anterior_button_down():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click2").play()
	



func _on_Anterior_mouse_entered():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click").play()
