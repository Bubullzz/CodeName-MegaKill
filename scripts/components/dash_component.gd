class_name DashComponent extends Node

@export var player: Node3D
@export var dash_cooldow: int = 3000
@export var dash_speed: float = 50.
@export var dash_duration: float = .5

var last_dash = -99999.
var dashing = false
var dash_direction: Vector2

func _process(delta: float) -> void:
	if not dashing:
		return
	player.velocity.x = dash_direction.x * dash_speed
	player.velocity.z = dash_direction.y * dash_speed
	
	player.move_and_slide()

func dash(dir: Vector2):
	var now = Time.get_ticks_msec()
	if now - last_dash < dash_cooldow:
		print("dash in cd")
		return
	print("starting dash")
	last_dash = now
	dash_direction = player.global_to_local_player_2d(dir)
	dashing = true
	player.velocity.y = 0
	await get_tree().create_timer(dash_duration).timeout
	dashing = false
