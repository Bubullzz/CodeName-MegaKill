extends CharacterBody3D

class_name Goon

@onready var move_component: MoveComponent = $MoveComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var target_player_component: TargetPlayerComponent = $TargetPlayerComponent
@onready var body_hurtbox: CustomHurtbox = $BodyHurtbox
@onready var weakspot_hurtbox: CustomHurtbox = $WeakspotHurtbox
@onready var rotation_component: RotationComponent = $RotationComponent

@export var damage = 10
var direction_to_player := Vector3(0.,0.,0.)

func _ready() -> void:
	$Spider_incroyable/AnimationPlayer.play("ArmatureAction")
	$Spider_incroyable/AnimationPlayer.speed_scale = 5
	health_component.died.connect(func(): queue_free())
	target_player_component.updated_direction \
		.connect(func(dir: Vector3): direction_to_player = dir.normalized())
	body_hurtbox.got_hit.connect(hit)
	weakspot_hurtbox.got_hit.connect(weakspot_hit)

static func instantiate() -> Goon:
	var instance: Goon = preload("res://scenes/goon.tscn").instantiate()
	var min_distance = 10
	var max_distance = 100
	var pos: Vector2 = Vector2(randi() % max_distance + min_distance, randi() % max_distance + min_distance)
	pos.x *= 1 if randi() % 2 else -1
	pos.y *= 1 if randi() % 2 else -1
	instance.position = Global.player.position + Vector3(pos.x, 0, pos.y)
	Global.goonManager.add_child(instance)
	return instance
	
func hit(w: Weapon):
	health_component.damage(w.get_damage())

func weakspot_hit(w: Weapon):
	health_component.damage(w.get_damage() * 3)

func _physics_process(delta: float) -> void:
	var dir_2d = Vector2(direction_to_player.x, direction_to_player.z)
	move_component.move(dir_2d, delta)
	rotation_component.rotate(dir_2d)
	
	
