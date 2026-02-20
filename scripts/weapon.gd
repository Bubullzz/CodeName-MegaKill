@abstract 
class_name Weapon

extends Node

signal weapon_updated(weapon)

var damage: int
var max_ammo: int
var curr_ammo: int # Should be array of specific / interesting bullets
var reload_time: float
var fire_rate: int # in msec
var last_shot: int = -1 # in msec too
var is_reloading = false
var weapon_name = "dummy"
@export var firerated_player: AudioStreamPlayer
var shoot_player: AudioStreamPlayer
var sprite: Sprite2D

func setup_sound_players(default = false):
	firerated_player = AudioStreamPlayer.new()
	shoot_player = AudioStreamPlayer.new()
	add_child(firerated_player)
	add_child(shoot_player)
	if default:
		firerated_player.stream = load("res://assets/sounds/weapons/default_firerated.mp3")
		shoot_player.stream = load("res://assets/sounds/weapons/default_shoot.mp3")
	else:
		firerated_player.stream = load("res://assets/sounds/weapons/%s_firerated.mp3" % [weapon_name])
		shoot_player.stream = load("res://assets/sounds/weapons/%s_shoot.mp3" % [weapon_name])

func _ready() -> void:
	curr_ammo = max_ammo

func reload():
	is_reloading = true
	await get_tree().create_timer(reload_time).timeout
	curr_ammo = max_ammo
	is_reloading = false
	
	weapon_updated.emit(self)

func can_shoot()-> bool:
	if is_reloading: print("reloading"); return false
	
	if curr_ammo == 0: 
		reload()
		print("no ammo")
		return false
	if Time.get_ticks_msec() < last_shot + fire_rate:
		print("firerated");
		firerated_player.play()
		return false
	
	return true 

func shoot()-> void:
	curr_ammo -= 1
	last_shot = Time.get_ticks_msec()
	shoot_player.play()
	
	weapon_updated.emit(self)
