extends Control

func _ready() -> void:
	Global.player.life_updated.connect(func (h): %ProgressBar.value = h)
