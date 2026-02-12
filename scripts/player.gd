extends CharacterBody3D

class_name Player

signal life_updated(health)

# How fast the player moves in meters per second.
@export var speed = 14
@export var jump_impulse: int
@export var health = 100
@export var healthBar: ProgressBar

var mouse_sensi = .005
var mouse_move: Vector2
var wish_dir: Vector3

func _init() -> void:
	Global.player = self

func _ready() -> void:
	#healthBar.min_value = 0
	#healthBar.max_value = health
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.screen_relative.x * mouse_sensi)
		$Camera3D.rotate_x(-event.screen_relative.y * mouse_sensi)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	var target_velocity = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	var input_dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
		
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	
	target_velocity.x = wish_dir.x * speed
	target_velocity.z = wish_dir.z * speed
	target_velocity.y = velocity.y - (Global.gravity * delta)
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse

	# Moving the Character
	velocity = target_velocity
	
	# Rotating the character
	move_and_slide()

func handle_goon_collision(goon: Goon) -> void:
	health -= goon.damage
	life_updated.emit(health)

func _on_hurtbox_entered(body: Node3D) -> void:
	if body is Goon: handle_goon_collision(body); return;
