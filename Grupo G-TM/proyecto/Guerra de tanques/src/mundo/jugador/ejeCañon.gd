extends Spatial

puppet var master_rotation = 1.0
const ROT_velocidad = 3.0

onready var parent = get_parent().get_parent()

var angularVel = 0.0






func _physics_process(delta):
	if Gamestate.informacion_del_jugador.net_id == 1:
		var input = Gamestate.get_my_input(parent.id)
		var toLookAt = parent.get_node("cameraTarget/Camera").vistaDeCamaraPlana(input.mouse_position, $head/BulletSpawner.global_transform[3].y)
		
		
		var rotacionVieja = -(self.rotation.y + get_parent().rotation.y - PI/2)
		var globalTrans = self.global_transform[3]
		var rotacionParaLlegarA = atan2(toLookAt.z - globalTrans.z, toLookAt.x - globalTrans.x) + (rotacionVieja - fmod(rotacionVieja,2*PI))
		var rotacionPosible = [rotacionParaLlegarA - 2*PI, rotacionParaLlegarA, rotacionParaLlegarA + 2*PI]
		var posibleDistancia = [	abs(rotacionPosible[0] - rotacionVieja),
									abs(rotacionPosible[1] - rotacionVieja),
									abs(rotacionPosible[2] - rotacionVieja)]
		var argmin = argmin(posibleDistancia)
		var rotacionDec = rotacionPosible[argmin]
		
		var direction = sign(rotacionDec - rotacionVieja)
		var distance = abs (posibleDistancia[argmin] - PI)
		self.rotation.y = self.rotation.y + direction * delta * min(distance,1) * ROT_velocidad
		rset("master_rotation", self.rotation.y)
	else:
		self.rotation.y = master_rotation


func argmin(valArray):
	var idx = 0
	var valmin = valArray[0]
	var argmin = 0
	for val in valArray :
		if val < valmin :
			valmin = val
			argmin = idx
		idx+=1
	return argmin
