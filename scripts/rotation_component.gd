class_name RotationComponent extends Node

@export var rotatee: Node3D

# I have to create the rotationcomponent
func rotate(direction: Vector2):
	# Face movement direction
	if direction.length_squared() > 0.001:
		var look_dir := Vector3(-direction.x, 0.0, -direction.y).normalized()
		rotatee.look_at(rotatee.global_position + look_dir, Vector3.UP)
