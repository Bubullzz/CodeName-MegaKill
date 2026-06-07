extends CharacterBody3D

class_name Player

signal hit(body) # Used to disply hit marker

@onready var health_component: HealthComponent = $HealthComponent
@onready var input_component: InputComponent = $InputComponent
@onready var move_component: MoveComponent = $MoveComponent

@onready var hurt_box: Area3D = $HurtBox
@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/Ray
@export var left_weapon: Weapon
@export var right_weapon: Weapon

var mouse_sensi = .005


func _ready() -> void:
	Global.player = self
	
	# Connect signals 
	health_component.died.connect(func(): print("I DIED !!!!!!"))
	input_component.jump_pressed_signal.connect(move_component.set_wants_jump)
	input_component.mouse_movement_updated.connect(mouse_moved)
	
	# Needs clearer handle of start shooting / stoped shooting 
	input_component.left_click.connect(func(): left_weapon.shoot(ray))
	input_component.right_click.connect(func(): right_weapon.shoot(ray))

	# Already editor-connected
	# hurt_box.area_entered.connect(_on_hurtbox_entered)

func handle_goon_collision(goon: Goon) -> void:
	health_component.damage(goon.damage)


func _on_hurtbox_entered(body: Node3D) -> void:
	if body is Goon: handle_goon_collision(body); return;


func mouse_moved(mouse_screen_relative: Vector2) -> void:
	rotate_y(-mouse_screen_relative.x * mouse_sensi)
	$Camera3D.rotate_x(-mouse_screen_relative.y * mouse_sensi)
	$Camera3D.rotation.x = clampf($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _physics_process(delta):
	var input_dir = input_component.move_dir.normalized()
	var direction = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	var direction2d = Vector2(direction.x, direction.z)
	move_component.move(direction2d, delta)
	return
