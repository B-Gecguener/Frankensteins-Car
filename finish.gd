extends Area3D

var win_screen: PackedScene 

func _on_body_entered(body: Node3D) -> void:
	if body is Player_1:
		get_tree().change_scene_to_packed(win_screen)
