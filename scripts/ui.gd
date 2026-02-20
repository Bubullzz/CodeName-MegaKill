extends Control

func _on_hit_marker_timer_timeout() -> void:
	%HitMarker.visible = false
	
func mark_hit(_b):
	await get_tree().create_timer(.1).timeout
	%HitMarker.visible = true
	%HitMarkerTimer.start()
	%HitMarkerSound.play()

func update_weapon_info(w: Weapon):
	if w == Global.player.right_weapon:
		%RightWeaponInfoLabel.text = "%d / %d" % [w.curr_ammo, w.max_ammo]
	elif w == Global.player.left_weapon:
		%LeftWeaponInfoLabel.text = "%d / %d" % [w.curr_ammo, w.max_ammo]
	else:
		print("this shouldn't be printed")

func _ready() -> void:
	Global.player.life_updated.connect(func (h): %ProgressBar.value = h)
	Global.player.hit.connect(mark_hit)
	Global.player.left_weapon.weapon_updated.connect(update_weapon_info)
	Global.player.right_weapon.weapon_updated.connect(update_weapon_info)
	update_weapon_info(Global.player.left_weapon)
	update_weapon_info(Global.player.right_weapon)
	
func _process(_delta):
	if Input.is_action_pressed("pause"):
		await get_tree().create_timer(.3).timeout
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_key_pressed(KEY_1):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
