extends Area3D
class_name CustomHurtbox

@export var goon: Goon

func hit(weapon: Weapon) -> void:
	goon.hit(weapon)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
