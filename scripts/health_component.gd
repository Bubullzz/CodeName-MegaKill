class_name HealthComponent extends Node

signal health_updated(current: float, max: float)
signal died

@export var max_health := 100.0
var current_health := 100.0

func update_health(amount: float):
	current_health = clamp(current_health + amount, 0.0, max_health)
	health_updated.emit(current_health, max_health)
	
func _ready() -> void:
	current_health = max_health
	
func damage(amount: float) -> void:
	update_health(-amount)
	if current_health == 0.0:
		died.emit()
		
func heal(amount: float) -> void:
	update_health(-amount)
