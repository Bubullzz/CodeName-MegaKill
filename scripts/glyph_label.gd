class_name GlyphLabel extends Control

var value: int
var printed_value: int
var associated_object: Node3D
var lifetime := 1.
var travelled_distance := 200
@onready var label: Label = %Label

static func instantiate(v: int, obj: Node3D) -> GlyphLabel:
	var instance: GlyphLabel = preload("res://scenes/glyph_label.tscn").instantiate()
	instance.value = v
	instance.associated_object = obj
	Global.tree.add_child(instance)
	return instance

func _ready():
	label.text = str(base_10_to_7_reversed(value))
	set_postition(Global.player.camera.unproject_position(associated_object.position))

	var r = randf()*2 - 1 # Random [-1,1]
	var random_dir = Vector2(r, abs(r) -1)
	random_dir = random_dir.normalized()
	var pos_tween = create_tween().tween_property(self, "position", position + random_dir * travelled_distance, lifetime)
	var trensparency_tween = create_tween().tween_property(self, "modulate:a",0., lifetime)
	
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	

func set_postition(p: Vector2):
	self.position = p

static func base_10_to_7_reversed(k: int) -> String:
	var base_7 = ""
	print("initial ", k)
	while k > 0:
		print("then ", k)
		base_7 += str(k % 7)
		k /= 7
	print(base_7)
	return base_7
