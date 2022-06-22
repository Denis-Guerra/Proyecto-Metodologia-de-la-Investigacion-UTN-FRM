extends Area


var destino

func _ready():
	destino = Vector3(100.255,3.5,-80)

func _on_Area4_body_entered(body):
	print("traza")
	if body.get_name() == "Jugador"+str(Gamestate.informacion_del_jugador.net_id):
		body.global_transform.origin = destino
