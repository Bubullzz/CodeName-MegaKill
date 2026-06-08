extends Node

@export var max_ammo: int
@export var reload_time: float
@export var fire_rate: int # in msec
@export var last_shot: int = -1
@export var is_automatic: bool
@export var parent_weapon: Weapon
var curr_ammo: int
var continue_shooting := false
var is_reloading := false
signal shot

func _ready() -> void:
	update_ammo(max_ammo)

func update_ammo(new_current_ammo):
	curr_ammo = new_current_ammo
	parent_weapon.ammo_updated.emit(curr_ammo, max_ammo)

func reload():
	is_reloading = true
	await get_tree().create_timer(reload_time).timeout
	update_ammo(max_ammo)
	is_reloading = false

func can_shoot():
	if is_reloading: print("reloading"); return false
	
	if curr_ammo == 0: 
		reload()
		continue_shooting = false
		print("no ammo")
		return false
	
	return true 

func shoot():
	shot.emit()
	update_ammo(curr_ammo - 1)
	print(curr_ammo)
	last_shot = Time.get_ticks_msec()


func start_shooting():
	var now = Time.get_ticks_msec()
	if !can_shoot():
		return
	
	continue_shooting = true
	# await between two start_shooting smaller than fire_rate
	var time_before_next_shot = (last_shot + fire_rate) - now
	
	if time_before_next_shot > 0:
		await get_tree().create_timer(time_before_next_shot).timeout
	
	shoot()
	if !is_automatic:
		continue_shooting = false
		return
	
	await get_tree().create_timer(float(fire_rate)/1000.).timeout
	# if automatic, loop on bullets while able
	while can_shoot() and continue_shooting:
		shoot()
		await get_tree().create_timer(float(fire_rate)/1000.).timeout

func stop_shooting():
	continue_shooting = false
