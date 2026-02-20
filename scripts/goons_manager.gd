extends Node3D

class_name GoonManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.goonManager = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
