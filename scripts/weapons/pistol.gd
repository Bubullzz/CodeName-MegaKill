extends Weapon

class_name Pistol

func _ready() -> void:
	max_ammo = 100
	damage = 2
	reload_time = 3.
	fire_rate = 1000
	weapon_name = "pistol"
	super._ready()
	setup_sound_players()
