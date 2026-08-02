extends Control

@export var game_scene_uid: String = "uid://d4nkcgmjgirl5"

func _ready() -> void:
	get_tree().paused = false

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_uid)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
