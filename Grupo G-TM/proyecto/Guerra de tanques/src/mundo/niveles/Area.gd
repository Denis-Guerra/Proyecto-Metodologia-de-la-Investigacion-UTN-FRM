extends Area

var destino
var destino2

func _ready():
	destino = Vector3(-105.627,3,8)
	destino2 = Vector3(101.255,3,10)
func _on_Area_body_entered(body):
	print("traza")
	if body.get_name() == "Jugador"+str(Gamestate.informacion_del_jugador.net_id):
		body.global_transform.origin = destino

func _on_Area2_body_entered(body):
	if body.get_name() == "Jugador"+str(Gamestate.informacion_del_jugador.net_id):
		body.global_transform.origin = destino2
