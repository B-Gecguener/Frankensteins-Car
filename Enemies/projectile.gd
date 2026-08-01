extends Node3D
class_name Projectile

@export var speed: float = 30.0
var flight_vector: Vector3 = Vector3()

func _process(delta: float) -> void:
	global_position += flight_vector * speed * delta
	if global_position.y <= 0:
		inpact()

func _on_hit_box_hit() -> void:
	inpact()

func inpact():
	queue_free()
