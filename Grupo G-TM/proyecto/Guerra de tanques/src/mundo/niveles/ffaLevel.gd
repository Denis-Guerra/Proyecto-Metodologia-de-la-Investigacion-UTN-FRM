extends Spatial


func actualizar_nuevo_jugador(net_id):
	$playersContainer.actualizar_nuevo_jugador(net_id)

func inicio_del_jugador():
	$playersContainer._configurar_jugadores()



remote func _servidor_coordina_inicio_jugador(id):
	Spawn_del_Jugador(id)
	rpc("Spawn_del_Jugador",id)


remote func Spawn_del_Jugador(id):
	$playersContainer.addPlayer(id)


func _on_btnAparecer_pressed():
	$Camera/btnAparecer.visible = false
	$Camera/btnAparecer.disabled = true
	if Gamestate.informacion_del_jugador.net_id == 1:
		_servidor_coordina_inicio_jugador(1)
		$Camera/btnSalir.visible = false
	else:
		rpc_id(1,"_servidor_coordina_inicio_jugador",Gamestate.informacion_del_jugador.net_id)



func _on_btnSalir_pressed():
	$Camera/btnSalir.visible = false
	$Camera/btnSalir.disabled = true
	get_tree().quit()
	
