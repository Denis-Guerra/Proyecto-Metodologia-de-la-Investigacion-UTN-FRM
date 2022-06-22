extends Control




func _on_quit_pressed():
	get_tree().quit(0)


func _on_backToMenu_pressed():
	get_tree().change_scene("res://src/UI/mainMenu.tscn")


func _on_volverMenu_button_down():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click2").play()


func _on_volverMenu_mouse_entered():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click").play()


func _on_quit_button_down():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click2").play()
	
	


func _on_quit_mouse_entered():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click").play()
