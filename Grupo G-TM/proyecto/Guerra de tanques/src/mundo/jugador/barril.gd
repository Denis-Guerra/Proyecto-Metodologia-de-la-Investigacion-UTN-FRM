extends Spatial

onready var bulletRes = preload("res://src/mundo/jugador/bala.tscn")


var timerFinished = true
onready var parent = get_parent().get_parent().get_parent()

var sistema_de_particulas = 4

var velocidad_bala_impulsada = 50.0
var velocidad_balas = 30.0

func _ready():
	
	for i in range(sistema_de_particulas-1):
		var agregar = $muzzleFire0.duplicate()
		self.add_child(agregar)
		agregar.name = "muzzleFire" + str(i+1)
		agregar = ($muzzleSmoke0.duplicate())
		agregar.name = "muzzleSmoke" + str(i+1)
		self.add_child(agregar)
	



func _physics_process(delta):
	if Gamestate.informacion_del_jugador.net_id == 1:
		var shotInput = Gamestate.get_my_input(parent.id).mouse_click
		if shotInput and timerFinished:
			var name = disparo()
			rpc("disparo", name)

var contador_de_disparo = 0
remote func disparo(name = null):
	
	var agregar = bulletRes.instance()
	if name != null:
		agregar.name = name
	else:
		
		agregar.name = str(parent.id) + str(contador_de_disparo)
		contador_de_disparo += 1
		contador_de_disparo = contador_de_disparo%999
	agregar.thrower = parent
	parent.get_parent().add_child(agregar)
	agregar.global_transform = $BulletSpawner.global_transform
	agregar.scale = Vector3.ONE
	agregar.rotate_object_local(Vector3.RIGHT, PI/2)
	var toDot = get_parent().global_transform.basis.xform(Vector3.FORWARD)
	var velocidadIncr = (parent.velocity as Vector3).dot(toDot)
	var toAddvelocidad = velocidad_bala_impulsada if Network.jugador[parent.id].bonuses.has(Gamestate.ImpulsoDeVelBala) else velocidad_balas
	agregar.velocidad = toAddvelocidad + velocidadIncr
	
	
	timerFinished = false
	$Tween.interpolate_property($closeMf, "light_energy",32,0,0.5,Tween.TRANS_CUBIC)
	$Tween.start()
	$Tween.interpolate_property($farMf, "light_energy",16,0,0.2,Tween.TRANS_CUBIC)
	$Tween.start()
	$Tween.interpolate_property($barrel, "translation",Vector3.FORWARD,Vector3.ZERO,0.5,Tween.TRANS_BOUNCE)
	$Tween.start()
	var baseTrans = self.translation
	$Tween.interpolate_property(self, "translation",baseTrans - 0.5 * Vector3.FORWARD, baseTrans, 1.0,Tween.TRANS_BOUNCE)
	$Tween.start()
	$Tween.interpolate_property(parent, "velocidad",parent.velocidad - velocidadIncr/2, parent.velocidad, 1.0, Tween.TRANS_CUBIC)
	particleEmit("muzzleFire")
	particleEmit("muzzleSmoke")
	$Timer.start(1.0)
	
	return agregar.name

var particleIdx = 0
func particleEmit(emitterStr):
	get_node(emitterStr + str(particleIdx)).emitting = true
	particleIdx = (particleIdx + 1 )%sistema_de_particulas



func _on_Timer_timeout():
	timerFinished = true
