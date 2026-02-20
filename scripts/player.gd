extends CharacterBody3D

class_name Player

signal life_updated(health)
signal hit(body) # Used to disply hit marker

# How fast the player moves in meters per second.
@export var speed = 14
@export var jump_impulse: int
@export var health = 100
@export var weapon: Weapon
var camera: Camera3D
var ray: RayCast3D
var mouse_sensi = .005
var mouse_move: Vector2
var wish_dir: Vector3

func handle_goon_collision(goon: Goon) -> void:
	health -= goon.damage
	life_updated.emit(health)

func try_shoot():
	if weapon.can_shoot():
		weapon.shoot()
		var first = ray.get_collider()
		if first is Goon:
			print("shot goon")
			hit.emit(first)
			first.hit(weapon)
		else:
			print("shot nothing")
	else: print("cannot shoot")
	
	


func _on_hurtbox_entered(body: Node3D) -> void:
	if body is Goon: handle_goon_collision(body); return;


func _init() -> void:
	Global.player = self

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera = $Camera3D
	ray = $Camera3D/Ray

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

	if Input.is_mouse_button_pressed(1):
		try_shoot()
