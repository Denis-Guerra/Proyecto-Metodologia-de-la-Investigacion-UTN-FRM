extends Node
var informacion_del_jugador = {
	name = "Player",                   
	net_id = 1,                        # por defecto cada jugador recibe una id
	listo_para_iniciar_juego = false,
	bonuses = [],
	tanque = "",
	posicion_tp = Vector3(40.793,0,63.101)
}

enum {ImpulsoDeVelocidad,turnBoost,ImpulsoDeVelBala,rebotebala,balaDividida}

var listaDeJugadores = {}

var sensibilidad = 2e-3
var posicion_del_mouse = Vector2.ZERO
var clickiado = false
func _ready():
	
	Network.connect("lista_de_jugadores_cambio",self,"_cambia_lista_jugadores")

func _process(delta):
	if Network.enUnServidor:
		if not informacion_del_jugador.net_id == 1:
			actualiza_server()

func _input(event):
	if event is InputEventMouseMotion:
	   posicion_del_mouse = event.position
	elif event is InputEventMouseButton:
		clickiado = (event as InputEventMouseButton).is_pressed()

func actualiza_server():
	rpc_id(1, "cola_entrada", gen_input(), informacion_del_jugador.net_id)

func gen_blank_input():
	var res = {}
	res["movement"] = Vector3.ZERO
	res["mouse_position"] = Vector2.ZERO
	res["mouse_click"] = true
	res["should_kill_myself"] = false
	return res

func gen_suicide_input():
	var res = {}
	res["movement"] = Vector3.ZERO
	res["mouse_position"] = Vector2.ZERO
	res["mouse_click"] = false
	res["should_kill_myself"] = true
	return res

func gen_input():
	var res = {}
	var move = Vector3.FORWARD * (int(Input.is_action_pressed("move_front")) - int(Input.is_action_pressed("move_back")))
	move += Vector3.RIGHT * (int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")))
	res["movement"] = move
	res["mouse_position"] = posicion_del_mouse
	res["mouse_click"] = clickiado
	res["should_kill_myself"] = false
	return res

func get_my_input(net_id):
	if net_id == 1:
		return gen_input()
	else:
		if listaDeJugadores.has(net_id):
			return listaDeJugadores[net_id]
		elif net_id < 0:
			return gen_blank_input()
		else:
			return gen_suicide_input()



remote func cola_entrada(input,id):
	listaDeJugadores[id]= input


func _cambia_lista_jugadores():
	listaDeJugadores = {}
	for playerIdx in Network.jugador:
		listaDeJugadores[playerIdx] = {}
