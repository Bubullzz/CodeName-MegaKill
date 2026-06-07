class_name MoveComponent extends Node

@export var body: CharacterBody3D
@export var speed := 8.0
@export var jump_velocity := 12.0
@export var gravity_multiplier := 3.0

var wants_jump := false

# helper to easily connect the signal
func set_wants_jump():
	wants_jump = true

func move(direction: Vector2, delta: float) -> void:
	direction = direction.normalized()
	# Top Down Movement
	body.velocity.x = direction.x * speed
	body.velocity.z = direction.y * speed
	
	# Gravity
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta * gravity_multiplier
		
	# Jump
	if wants_jump and body.is_on_floor():
		body.velocity.y = jump_velocity
	wants_jump = false
	
	body.move_and_slide()
	return
	
