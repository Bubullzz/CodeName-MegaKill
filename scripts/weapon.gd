class_name Weapon extends Node3D

signal weapon_updated(weapon)
signal hit(damage: float, target: Node3D)
signal ammo_updated(current_ammo: int, max_ammo: int)

@onready var ammo_component = $AmmoComponent
@onready var shooting_component = $ShootingComponent
@onready var weapon_data_component = $WeaponDataComponent

func _ready() -> void:
	ammo_component.shot.connect(func(): shooting_component.shoot(Global.player.ray))
	
func get_damage():
	return weapon_data_component.damage

func start_shooting_weapon()-> void:
	ammo_component.start_shooting()

func stop_shooting_weapon()-> void:
	ammo_component.stop_shooting()
	
func get_curr_ammo():
	return ammo_component.curr_ammo

func get_max_ammo():
	return ammo_component.max_ammo
