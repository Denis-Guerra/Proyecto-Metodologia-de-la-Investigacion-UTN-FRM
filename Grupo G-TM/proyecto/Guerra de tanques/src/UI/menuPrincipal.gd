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
	$PreGameClientPanel.visible = true
	$PanelRed.visible = false


func _on_host_pressed():
	Gamestate.informacion_del_jugador.name = $PanelRed/nombreJugador.text
	Network.create_server()


func _on_join_pressed():
	Gamestate.informacion_del_jugador.name = $PanelRed/nombreJugador.text
	Network.unirse_a_servidor($PanelRed/serverIP.text)

func _on_Select_Level_pressed():
	Network.mapa_selecionado()

func _on_port_text_changed(new_text):
	Network.info_servidor.puerto_usado = int(new_text)



