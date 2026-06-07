class_name InputComponent extends Node

var move_dir: Vector2 = Vector2.ZERO 
var mouse_screen_relative: Vector2 = Vector2.ZERO
var jump_pressed := false
var hurt_pressed := false
var heal_pressed := false
signal jump_pressed_signal
signal mouse_updated

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_screen_relative = event.screen_relative
		mouse_updated.emit(mouse_screen_relative)
	if Input.is_key_pressed(KEY_0):
		Goon.instantiate()


func update() -> void:
	move_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	jump_pressed = false
	if Input.is_action_just_pressed("jump"):
		jump_pressed = true
		jump_pressed_signal.emit()
