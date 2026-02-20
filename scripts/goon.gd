extends CharacterBody3D

class_name Goon

var move_speed = 10.
var health = 40
var target: CharacterBody3D = null
@export var damage = 10

static func instantiate() -> Goon:
	var instance: Goon = preload("res://scenes/goon.tscn").instantiate()
	var min_distance = 10
	var max_distance = 100
	var pos: Vector2 = Vector2(randi() % max_distance + min_distance, randi() % max_distance + min_distance)
	pos.x *= 1 if randi() % 2 else -1
	pos.y *= 1 if randi() % 2 else -1
	instance.position = Global.player.position + Vector3(pos.x, 0, pos.y)
	Global.goonManager.add_child(instance)
	return instance
	
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
	
