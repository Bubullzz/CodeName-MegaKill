extends Node

@export var outer: MeshInstance3D
@export var middle: MeshInstance3D
@export var inner: MeshInstance3D

@export var speed_outer = 1.
@export var speed_middle = 1.
@export var speed_inner = 1.

func _process(delta: float) -> void:
	outer.rotate(Vector3(1,0,0), delta*speed_outer)
	middle.rotate(Vector3(1,1,0).normalized(), delta*speed_middle)
	inner.rotate(Vector3(0,0,1), delta*speed_inner)
