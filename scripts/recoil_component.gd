extends Node

@export var recoil_rotation: float
@export var up_time: float
@export var down_time: float
@export var pivot: Node3D
@export var recoil_transform: Vector2
var rot_tween: Tween
var transform_tween: Tween
func recoil():
	if rot_tween:
		rot_tween.kill()
	if transform_tween:
		transform_tween.kill()
	rot_tween = get_tree().create_tween()
	rot_tween.tween_property(pivot, "rotation:x", recoil_rotation, up_time).set_trans(Tween.TRANS_CUBIC)
	rot_tween.tween_property(pivot, "rotation:x", 0, down_time).set_trans(Tween.TRANS_SINE)
	
	transform_tween = get_tree().create_tween()
	transform_tween.tween_property(pivot, "position", Vector3(0,recoil_transform.x, recoil_transform.y), up_time)
	transform_tween.tween_property(pivot, "position", Vector3(0,0,0), down_time)
