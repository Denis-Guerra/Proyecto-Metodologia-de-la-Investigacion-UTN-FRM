extends Area


var destino

func _ready():
	destino = Vector3(101.255,3,10)

func _on_Area2_body_entered(body):
	if body.get_name() == "Jugador"+str(Gamestate.informacion_del_jugador.net_id):
		body.global_transform.origin = destino

