extends Node

signal hit_something(target: Node3D)
@export var weapon: Weapon

# When this is called we already knwo we can shoot
func shoot(ray: RayCast3D)-> void:
	var first = ray.get_collider()
	if first:
		hit_something.emit(first)
		first.hit(weapon)
		
