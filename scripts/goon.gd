extends CharacterBody3D

class_name Goon

var move_speed = 10.
var health = 20
var target: CharacterBody3D = null

func _physics_process(delta: float) -> void:
	var dir = (Global.player.position - self.position).normalized()
	dir.y -= delta * Global.gravity
	self.velocity = dir * move_speed
	move_and_slide()
	pass
	
