extends Node3D
class_name Batterie

var player: Player_1
var velocity: Vector3

func _physics_process(delta: float) -> void:
	if player:
		velocity += global_position.direction_to(player.global_position).normalized()
		global_position += velocity * delta

func _on_body_entered(body: Node3D) -> void:
	if body is Player_1:
		player = body
