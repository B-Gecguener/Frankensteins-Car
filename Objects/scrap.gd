extends Area3D
class_name Scrap

var player: Player_1
var velocity: Vector3

@onready var dect_area: Area3D = $Area3D

func _physics_process(delta: float) -> void:
	if player:
		velocity += global_position.direction_to(player.global_position).normalized()
		global_position += velocity * delta
	if global_position.y > 0:
		velocity += Vector3(0,-1,0);
		global_position += velocity
	else: 
		velocity.y = 0

func body_entered(body: Node3D) -> void:
	if body is Player_1:
		player = body
