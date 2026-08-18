@tool
extends MeshInstance3D

const size := 256.0

@export_range(4, 256, 4) var resolution := 32:
	set(new):
		resolution = new
		update_mesh()

@export_range(.001, .1, .001) var distance_factor := 32.0:
	set(new):
		distance_factor = new
		update_mesh()

@export var noise: FastNoiseLite:
	set(new):
		noise = new
		update_mesh()
		if noise:
			noise.changed.connect(update_mesh)

@export_range(4, 128, 4) var height := 64.0:
	set(new):
		height = new
		update_mesh()

@export_range(4, 128, 4) var middle_offset := 64.0:
	set(new):
		middle_offset = new
		update_mesh()

@export var color_grad: Gradient:
	set(new):
		color_grad = new
		update_mesh()


func _ready() -> void:
	update_mesh()


func get_height(x: float, y: float) -> float:
	return noise.get_noise_2d(x, y) * height


func dist_to_center(x: float, y: float) -> float:
	return max(0.0, Vector2(x, y).length() - middle_offset)


func get_vertex(x: float, z: float) -> Vector3:
	var y := get_height(x, z)
	y += dist_to_center(x, z)

	return Vector3(x, y, z)


func update_mesh() -> void:
	if not is_inside_tree():
		return

	if noise == null:
		return

	print("updating mesh")

	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	var colors := PackedColorArray()

	var step := size / float(resolution)

	for z in range(resolution):
		for x in range(resolution):
			var x0 := -size / 2.0 + x * step
			var z0 := -size / 2.0 + z * step
			var x1 := x0 + step
			var z1 := z0 + step

			var v0 := get_vertex(x0, z0)
			var v1 := get_vertex(x1, z0)
			var v2 := get_vertex(x0, z1)
			var v3 := get_vertex(x1, z1)

			# Triangle 1
			add_flat_triangle(
				vertices,
				normals,
				colors,
				v0,
				v1,
				v2
			)

			# Triangle 2
			add_flat_triangle(
				vertices,
				normals,
				colors,
				v1,
				v3,
				v2
			)

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)

	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_COLOR] = colors

	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(
		Mesh.PRIMITIVE_TRIANGLES,
		arrays
	)

	var material := StandardMaterial3D.new()
	material.vertex_color_use_as_albedo = true

	array_mesh.surface_set_material(0, material)

	mesh = array_mesh


func add_flat_triangle(
	vertices: PackedVector3Array,
	normals: PackedVector3Array,
	colors: PackedColorArray,
	a: Vector3,
	b: Vector3,
	c: Vector3
) -> void:
	# Flat normal pointing upward
	var normal := (c - a).cross(b - a).normalized()

	vertices.append(a)
	vertices.append(b)
	vertices.append(c)

	normals.append(normal)
	normals.append(normal)
	normals.append(normal)

	colors.append(get_color(a.y))
	colors.append(get_color(b.y))
	colors.append(get_color(c.y))


func get_color(h: float) -> Color:
	if color_grad == null:
		return Color.WHITE

	return color_grad.sample(
		clamp(h / height + 0.1, 0.0, 1.0)
	)
