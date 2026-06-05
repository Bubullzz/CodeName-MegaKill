class_name CustomHurtbox extends Area3D

signal got_hit(w: Weapon)

func hit(weapon: Weapon) -> void:
	got_hit.emit(weapon)
	print("hit")
