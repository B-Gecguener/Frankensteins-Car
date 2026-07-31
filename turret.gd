extends Node3D

@export var car: CharacterBody3D
@export var turret: Node3D
@export var cannon: Node3D
@onready var detection_area: Area3D = $"Area3D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if car:
		turret.look_at(car.global_position+Vector3(0,global_position.y,0))
		cannon.look_at(car.global_position)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		car = body


func _on_area_3d_body_exited(body: Node3D) -> void:
	for dect_body in detection_area.get_overlapping_bodies():
		if dect_body is Player:
			return
	car = null
