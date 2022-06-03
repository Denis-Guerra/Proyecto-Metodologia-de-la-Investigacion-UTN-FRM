extends Spatial


func actualizar_nuevo_jugador(net_id):
	$playersContainer.actualizar_nuevo_jugador(net_id)

func inicio_del_jugador():
	$playersContainer._configurar_jugadores()



func _on_SpawnButton_pressed():
	$Camera/SpawnButton.visible = false
	$Camera/SpawnButton.disabled = true
	if Gamestate.informacion_del_jugador.net_id == 1:
		_servidor_coordina_inicio_jugador(1)
	else:
		rpc_id(1,"_servidor_coordina_inicio_jugador",Gamestate.informacion_del_jugador.net_id)

remote func _servidor_coordina_inicio_jugador(id):
	Spawn_del_Jugador(id)
	rpc("Spawn_del_Jugador",id)


remote func Spawn_del_Jugador(id):
	$playersContainer.addPlayer(id)
