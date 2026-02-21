extends CustomHurtbox
class_name WeakspotHurtbox

func hit(weapon: Weapon) -> void:
	print("weakspot hit")
	goon.weakspot_hit(weapon)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
