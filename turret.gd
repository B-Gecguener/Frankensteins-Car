extends Node3D

@export var car: CharacterBody3D
@export var turret: Node3D
@export var cannon: Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	turret.look_at(car.global_position+Vector3(0,global_position.y,0))
	cannon.look_at(car.global_position)
