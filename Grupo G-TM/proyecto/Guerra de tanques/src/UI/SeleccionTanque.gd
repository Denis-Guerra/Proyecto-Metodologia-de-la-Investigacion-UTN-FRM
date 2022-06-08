extends Control


func botones_desactivados():
	$Panel/seleccionNivel.disabled = true
	$Panel/levelDisplayer/Siguiente.disabled = true
	$Panel/levelDisplayer/Anterior.disabled = true


var tanque1: String = "res://src/mundo/jugador/tanque.tscn"
var tanque2: String = "res://src/mundo/jugador/tanque2.tscn"
var tanque3: String = "res://src/mundo/jugador/tanque3.tscn"

#se crea los botones

func _on_btnTanque1_pressed():
	Gamestate.informacion_del_jugador.tanque = tanque1
	Network.seleccion_mapa()
	get_tree().change_scene("res://src/UI/playerLevelSelection.tscn")


func _on_btnTanque2_pressed():
	Gamestate.informacion_del_jugador.tanque = tanque2
	Network.seleccion_mapa()
	get_tree().change_scene("res://src/UI/playerLevelSelection.tscn")


func _on_btnTanque3_pressed():
	Gamestate.informacion_del_jugador.tanque = tanque3
	Network.seleccion_mapa()
	get_tree().change_scene("res://src/UI/playerLevelSelection.tscn")
