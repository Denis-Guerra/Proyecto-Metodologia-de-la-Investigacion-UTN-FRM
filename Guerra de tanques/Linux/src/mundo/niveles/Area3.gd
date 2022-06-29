extends Area

var destino

func _ready():
	destino = Vector3(-20.486,3.5,90.446)

func _on_Area3_body_entered(body):
	print("traza")
	if body.get_name() == "Jugador"+str(Gamestate.informacion_del_jugador.net_id):
		body.global_transform.origin = destino
