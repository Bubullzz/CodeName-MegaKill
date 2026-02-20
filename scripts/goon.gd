extends CharacterBody3D

class_name Goon

var move_speed = 10.
var health = 40
var target: CharacterBody3D = null
@export var damage = 10

func hit(w: Weapon):
	health -= w.damage
	if health <= 0:
		queue_free()

func _physics_process(delta: float) -> void:
	var dir = (Global.player.position - self.position).normalized()
	dir.y -= delta * Global.gravity
	self.velocity = dir * move_speed
	move_and_slide()
	pass
	
