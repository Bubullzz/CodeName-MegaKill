extends CharacterBody3D

class_name Player

signal hit(body) # Used to disply hit marker

@onready var health_component: HealthComponent = $HealthComponent
@onready var input_component: InputComponent = $InputComponent
@onready var move_component: MoveComponent = $MoveComponent
@onready var dash_component: DashComponent = $DashComponent

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
	input_component.dash.connect(func(): dash_component.dash(input_component.move_dir.normalized()))
	
	# Needs clearer handle of start shooting / stoped shooting 
	input_component.left_click.connect(func(): left_weapon.start_shooting_weapon())
	input_component.right_click.connect(func(): right_weapon.start_shooting_weapon())
	input_component.left_click_released.connect(func(): left_weapon.stop_shooting_weapon())
	input_component.right_click_released.connect(func(): right_weapon.stop_shooting_weapon())
	# Already editor-connected
	# hurt_box.area_entered.connect(_on_hurtbox_entered)
	right_weapon.reparent.call_deferred($Camera3D/RightWeaponPos, false)
	left_weapon.reparent.call_deferred($Camera3D/LeftWeaponPos, false)
	right_weapon.position = Vector3(0,0,0)
	left_weapon.position = Vector3(0,0,0)
	
func handle_goon_collision(goon: Goon) -> void:
	health_component.damage(goon.damage)


func _on_hurtbox_entered(body: Node3D) -> void:
	if body is Goon: handle_goon_collision(body); return;


func mouse_moved(mouse_screen_relative: Vector2) -> void:
	rotate_y(-mouse_screen_relative.x * mouse_sensi)
	$Camera3D.rotate_x(-mouse_screen_relative.y * mouse_sensi)
	$Camera3D.rotation.x = clampf($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func global_to_local_player_3d(vec: Vector3) -> Vector3:
	return self.global_transform.basis * vec

func global_to_local_player_2d(vec: Vector2) -> Vector2:
	var v = global_to_local_player_3d(Vector3(vec.x, 0., vec.y))
	return Vector2(v.x, v.z)

func _physics_process(delta):
	var input_dir = input_component.move_dir.normalized()
	var direction = global_to_local_player_2d(input_dir)
	move_component.move(direction, delta)
	return
