extends KinematicBody

export var id = -1

puppet var master_translation


puppet var velocidad1 = Vector3.ZERO
const gravedad = 50.0
puppet var yaw = 0


var velocidad = 20.0
var impulso_velocidad = 25.0
var fuerza_salto = 20.0


var impulsoHaciaAdelante = 0.0
var ROT_velocidad = 1.0
var BSTD_ROT_velocidad = 2.5
var accvelocidad = 2.0
var deccvelocidad = 4.0



signal muerte



func _ready():
	master_translation = self.translation
	print("player added")
	self.connect("muerte",Network,"_jugador_a_muerto")



var lastYaw = 0
func _physics_process(delta):
	if Gamestate.informacion_del_jugador.net_id != 1:
		self.translation = master_translation
	else:
		var input = Gamestate.get_my_input(id)
		if input.should_kill_myself:
			rpc("Destruir")
			Destruir()
		var movementInput = (input.movement as Vector3)
		var xyInput = (movementInput)
		velocidad1 += Vector3.DOWN * gravedad * delta
		if abs(xyInput.dot(Vector3.FORWARD)) < 0.3:
			impulsoHaciaAdelante -= sign(impulsoHaciaAdelante) * deccvelocidad * delta * min(abs(impulsoHaciaAdelante),1.0)
		else:
			impulsoHaciaAdelante += xyInput.dot(Vector3.FORWARD) * accvelocidad * delta
		
		
		impulsoHaciaAdelante = clamp(impulsoHaciaAdelante,-1,1)
		var mi_Rot_velocidad = BSTD_ROT_velocidad if Network.jugador[id].bonuses.has(Gamestate.turnBoost) else ROT_velocidad
		
		yaw -= xyInput.x * mi_Rot_velocidad * delta
		var miVelocidad =impulso_velocidad if Network.jugador[id].bonuses.has(Gamestate.ImpulsoDeVelocidad) else velocidad
		velocidad1 = (miVelocidad * impulsoHaciaAdelante * Vector3.FORWARD).rotated(Vector3.UP, yaw) + Vector3.UP * velocidad1.y
		
		if Input.is_action_just_pressed("ui_accept"):
			Network.server_coordinate_receive_boost(id,Gamestate.rebotebala)
		rset("velocidad1",self.velocidad1)
		rset("master_translation", self.translation)
		rset("yaw", self.yaw)
	velocidad1 = self.move_and_slide(velocidad1, Vector3.UP)
	Actualiza_Cuerpo()
	lastYaw = yaw

 

func Actualiza_Cuerpo():
	$body.rotation = Vector3.ZERO
	$body.rotate(Vector3.UP, yaw)
	
	$CollisionShape.rotation = Vector3.ZERO
	$CollisionShape.rotate(Vector3.UP, yaw)
	var Velocidad_Plana = Vector2(velocidad1.x,velocidad1.z)
	$body/caterpillar.translation = max(Velocidad_Plana.length()/velocidad*0.3, 0.2 if yaw != lastYaw else 0.0)*(Vector3.ONE * .5 - Vector3(randf(),randf(),randf()))
	$body/body.translation = Velocidad_Plana.length()/velocidad*0.1*(Vector3.ONE * .5 - Vector3(randf(),randf(),randf()))
	

#funcion de camara jugador

func Actualiza_camara():
	if id == Gamestate.informacion_del_jugador.net_id:
		$cameraTarget/Camera.current = true
	else:
		$cameraTarget/Camera.current = false


func deal_damage():
	if Gamestate.informacion_del_jugador.net_id == 1:
		rpc("Destruir")
		Destruir()


remote func Destruir():
	emit_signal("muerte",id)
	queue_free()


