extends KinematicBody

puppet var posicionMaestra = null

var velocidad = 30.0
var lanzada
var lanzadaID = 0
var rebote = false
func _ready():
	lanzadaID = lanzada.id


func _physics_process(delta):
	var col = self.move_and_collide(self.transform.basis.xform(Vector3.FORWARD * velocidad) * delta)
	if Gamestate.informacion_del_jugador.net_id == 1:
		rset("posicionMaestra",self.translation)
	elif posicionMaestra != null:
		self.translation = posicionMaestra
	
	if not col == null:
		var cuerpo = (col as KinematicCollision).collider
		if cuerpo.is_in_group("damageable") :
			cuerpo.deal_damage()
			if Gamestate.informacion_del_jugador.net_id == 1:
				self.queue_free()
				rpc("remote_queue_free")
		elif Network.jugador[lanzadaID].bonuses.has(Gamestate.rebotebala) and not rebote:
			bounce(col)
		else:
			if Gamestate.informacion_del_jugador.net_id == 1:
				self.queue_free()
				rpc("remote_queue_free")

remote func remote_queue_free():
	self.queue_free()




func bounce(col : KinematicCollision):
	var normal = col.normal
	var direction = self.global_transform.basis.xform(Vector3(Vector3.FORWARD))
	var anguloIndice = acos((-normal).dot(direction))
	var toRefl = sign(Vector3(normal.z,0,-normal.x).dot(direction))
	
	self.rotation.y = PI + atan2(normal.x,normal.z) + toRefl * anguloIndice
	rebote = true




func _on_Timer_timeout():
	$cuerpo.disabled = false # Replace with function cuerpo.
