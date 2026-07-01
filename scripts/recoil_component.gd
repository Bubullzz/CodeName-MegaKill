extends Node

@export var max_angle: float
@export var up_time: float
@export var down_time: float
@export var pivot: Node3D

var rot_tween:Tween

func recoil():
	if rot_tween:
		rot_tween.kill()
	rot_tween = get_tree().create_tween()
	rot_tween.tween_property(pivot, "rotation:x", max_angle, up_time).set_trans(Tween.TRANS_CUBIC)
	rot_tween.tween_property(pivot, "rotation:x", 0, down_time).set_trans(Tween.TRANS_SINE)
