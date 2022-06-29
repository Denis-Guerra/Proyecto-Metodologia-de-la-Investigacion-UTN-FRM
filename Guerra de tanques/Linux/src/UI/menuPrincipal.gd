extends Control
#127.0.0.1
#localhost
#192.168.1.27

func _ready():
	Network.connect("creacion_de_server", self, "_host_iniciado")
	Network.connect("conexion_lista", self, "_si_unido_al_servidor")

func _host_iniciado():
	$PanelPreJuego.visible = true
	$PanelRed.visible = false

func _si_unido_al_servidor():
	#$panelClientePreJuego.visible = true
	$PanelRed.visible = false
	get_tree().change_scene("res://src/UI/SeleccionTanque.tscn")


func _on_host_pressed():
	Gamestate.informacion_del_jugador.name = $PanelRed/nombreJugador.text
	Network.create_server()


func _on_join_pressed():
	Gamestate.informacion_del_jugador.name = $PanelRed/nombreJugador.text
	Network.unirse_a_servidor($PanelRed/serverIP.text)



func _on_port_text_changed(new_text):
	Network.info_servidor.puerto_usado = int(new_text)





func _on_seleccionTanque_pressed():
	get_tree().change_scene("res://src/UI/SeleccionTanque.tscn")

func _on_host_mouse_entered():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click").play()


func _on_Unirse_mouse_entered():
	 get_tree().get_nodes_in_group("sonidos")[0].get_node("click").play()



func _on_seleccionTanque_mouse_entered():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click").play()


func _on_Unirse_button_down():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click2").play()


func _on_host_button_down():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click2").play()


func _on_seleccionTanque_button_down():
	get_tree().get_nodes_in_group("sonidos")[0].get_node("click2").play()
	
var musica_fondo = preload("res://Denny Schneidemesser - Entering the Stronghold.ogg")

func _ready2():
	MusicaFondo.musica_fondo(musica_fondo)

		
