extends Control

func _on_hit_marker_timer_timeout() -> void:
	%HitMarker.visible = false
	
func mark_hit(_b):
	await get_tree().create_timer(.1).timeout
	%HitMarker.visible = true
	%HitMarkerTimer.start()
	%HitMarkerSound.play()

func update_left_label_info(current_ammo: int, max_ammo: int):
	%LeftWeaponInfoLabel.text = "%d / %d" % [current_ammo,max_ammo]

func update_right_label_info(current_ammo: int, max_ammo: int):
	%RightWeaponInfoLabel.text = "%d / %d" % [current_ammo,max_ammo]


func _ready() -> void:
	Global.player.health_component.health_updated.connect(func (curr, _max): %ProgressBar.value = curr)
	Global.player.hit.connect(mark_hit)
	Global.player.left_weapon.ammo_updated.connect(update_left_label_info)
	Global.player.right_weapon.ammo_updated.connect(update_right_label_info)
	
func _process(_delta):
	if Input.is_action_pressed("pause"):
		await get_tree().create_timer(.3).timeout
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_key_pressed(KEY_1):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
