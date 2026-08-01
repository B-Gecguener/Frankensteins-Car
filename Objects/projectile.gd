extends Node3D
class_name Projectile

@export var speed: float = 30.0
var flight_vector: Vector3 = Vector3()
var shooter: HurtBox = null   # set by whoever fired this, before adding it to the tree

var impact_ani: PackedScene = load("res://Objects/impact.tscn")
var timer: SceneTreeTimer

@onready var hit_box: HitBox = $HitBox

func _ready() -> void:
	hit_box.shooter = shooter
	timer = get_tree().create_timer(4.0)
	timer.timeout.connect(queue_free)

func _process(delta: float) -> void:
	global_position += flight_vector * speed * delta
	if global_position.y <= 0:
		inpact()

func _on_hit_box_hit() -> void:
	remove_self()

func inpact():
	var impact: Node3D = impact_ani.instantiate()
	impact.get_children()[0].animation_finished.connect(impact.queue_free)
	get_parent().get_parent().add_child(impact)
	impact.global_position = global_position
	remove_self()

func remove_self():
	queue_free()
