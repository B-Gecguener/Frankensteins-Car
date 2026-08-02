extends Node3D

@export var next_level: PackedScene


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player_1:
		Levelmanager.save_player(body)
		body.get_parent().remove_child(body)
		call_deferred("change_level")

func change_level():
	if next_level:
		get_tree().change_scene_to_packed(next_level)
