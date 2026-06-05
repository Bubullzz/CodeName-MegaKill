class_name TargetPlayerComponent extends Node3D

@export var delay_between_updates := .1
var direction = Vector3(0.,0.,0.)
signal updated_direction(dir: Vector3)

func update_direction():
	direction = Global.player.position - self.global_position
	updated_direction.emit(direction)
	await get_tree().create_timer(delay_between_updates).timeout
	update_direction()

func _ready():
	update_direction()
