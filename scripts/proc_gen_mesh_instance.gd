@tool
extends MeshInstance3D

const size:= 256

@export_range(4, 256, 4) var resolution := 32:
	set(new):
		resolution = new
		update_mesh()

@export_range(.001, .1, .001) var distance_factor := 32:
	set(new):
		distance_factor = new
		update_mesh()

@export var noise: FastNoiseLite:
	set(new):
		noise = new
		update_mesh()
		if noise:
			noise.changed.connect(update_mesh)

@export_range(4, 128, 4) var height := 64:
	set(new):
		height = new
		update_mesh()

@export_range(4, 128, 4) var middle_offset := 64:
	set(new):
		middle_offset = new
		update_mesh()

@export var color_grad :Gradient :
	set(new):
		color_grad = new
		update_mesh()

func _ready() -> void:
	update_mesh()
	
func get_normal(x: float, y: float) -> Vector3:
	var epsilon := size / resolution
	var normal := Vector3(
		(get_height(x + epsilon, y) - get_height(x - epsilon, y)) / (2.0 * epsilon),
		1.0,
		(get_height(x, y + epsilon) - get_height(x, y - epsilon)) / (2.0 * epsilon),
	)
	return normal.normalized()
	
func get_height(x,y):
	return noise.get_noise_2d(x,y) * height

func dist_to_center(x,y) -> float:
	return max(0, Vector2(x,y).length() - middle_offset)
	
func update_mesh() -> void:
	print("updating mesh")
	var plane := PlaneMesh.new()
	plane.subdivide_depth = resolution
	plane.subdivide_width = resolution
	plane.size = Vector2(size, size)
	
	var plane_arrays := plane.surface_get_arrays(0)
	var vertex_array: PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_VERTEX]
	var normal_array: PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_NORMAL]
	var tangent_array: PackedFloat32Array = plane_arrays[ArrayMesh.ARRAY_TANGENT]
	var color_array:= PackedColorArray()
	color_array.resize(vertex_array.size())
	
	for i:int in vertex_array.size():
		var vertex := vertex_array[i]
		var normal := Vector3.UP
		var tangent := Vector3.RIGHT
		if noise and color_grad:
			var h = get_height(vertex.x, vertex.z)
			h += dist_to_center(vertex.x, vertex.z) * 1.
			vertex.y = h
			color_array[i] = color_grad.sample(h / float(height) + randf()/10.)
			normal = get_normal(vertex.x, vertex.z)
			tangent = normal.cross(Vector3.UP)
		vertex_array[i] = vertex
		normal_array[i] = normal
		tangent_array[4 * i] = tangent.x
		tangent_array[4 * i + 1] = tangent.y
		tangent_array[4 * i + 2] = tangent.z
	
	plane_arrays[ArrayMesh.ARRAY_COLOR] = color_array
	var array_mesh:= ArrayMesh.new()
	var material := StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, plane_arrays)
	array_mesh.surface_set_material(0, material)
	mesh = array_mesh
