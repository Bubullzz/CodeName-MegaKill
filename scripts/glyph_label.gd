class_name GlyphLabel extends Control

var value: int
var printed_value: int
@onready var label: Label = %Label

static func instantiate(v: int) -> GlyphLabel:
	var instance: GlyphLabel = preload("res://scenes/glyph_label.tscn").instantiate()
	instance.value = v
	Global.tree.add_child(instance)
	return instance

func _ready():
	label.text = str(base_10_to_7_reversed(value))
	await get_tree().create_timer(1.).timeout
	queue_free()
	

static func base_10_to_7_reversed(k: int) -> String:
	var base_7 = ""
	print("initial ", k)
	while k > 0:
		print("then ", k)
		base_7 += str(k % 7)
		k /= 7
	print(base_7)
	return base_7
