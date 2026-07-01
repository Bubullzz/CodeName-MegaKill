class_name Weapon extends Node3D

signal weapon_updated(weapon)
signal hit(damage: float, target: Node3D)
signal ammo_updated(current_ammo: int, max_ammo: int)

var weapon_name = "dummy"
var ammo_component: Node
var shooting_component: Node
var recoil_component: Node

func _ready() -> void:
	ammo_component = $AmmoComponent
	shooting_component = $ShootingComponent
	recoil_component = $RecoilComponent
	ammo_component.shot.connect(func(): shooting_component.shoot(Global.player.ray))
	ammo_component.shot.connect(recoil_component.recoil)
	

func get_damage():
	return 0

func start_shooting_weapon()-> void:
	ammo_component.start_shooting()

func stop_shooting_weapon()-> void:
	ammo_component.stop_shooting()
	
func get_curr_ammo():
	return ammo_component.curr_ammo

func get_max_ammo():
	return ammo_component.max_ammo
