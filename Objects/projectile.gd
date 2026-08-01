extends Node3D
class_name Projectile

@export var speed: float = 30.0
var flight_vector: Vector3 = Vector3()

var impact_ani: PackedScene = load("res://Objects/impact.tscn")

func _process(delta: float) -> void:
	global_position += flight_vector * speed * delta
	if global_position.y <= 0:
		inpact()

func _on_hit_box_hit() -> void:
	queue_free()

func inpact():
	var impact: Node3D = impact_ani.instantiate()
	impact.get_children()[0].animation_finished.connect(impact.queue_free)
	get_parent().get_parent().add_child(impact)
	impact.global_position = global_position
	queue_free()
