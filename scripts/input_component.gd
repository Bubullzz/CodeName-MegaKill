class_name InputComponent extends Node

var move_dir: Vector2 = Vector2.ZERO 
var mouse_screen_relative: Vector2 = Vector2.ZERO
var jump_pressed := false
var hurt_pressed := false
var heal_pressed := false
signal jump_pressed_signal
signal mouse_movement_updated
signal left_click
signal right_click
signal left_click_released
signal right_click_released

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	# WASD
	move_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	# Jump
	jump_pressed = false
	if Input.is_action_just_pressed("jump"):
		jump_pressed = true
		jump_pressed_signal.emit()
	
	# Rotate camera/body
	if event is InputEventMouseMotion:
		mouse_screen_relative = event.screen_relative
		mouse_movement_updated.emit(mouse_screen_relative)
		
	# Left/Right click
	if Input.is_action_just_pressed("left_click"):
		left_click.emit()
	if Input.is_action_just_pressed("right_click"):
		right_click.emit()
	if Input.is_action_just_released("left_click"):
		left_click_released.emit()
	if Input.is_action_just_released("right_click"):
		right_click_released.emit()
	
	# Bullshit blazing
	if Input.is_key_pressed(KEY_0):
		Goon.instantiate()
