extends Control

@export_file("*.tscn") var main_menu_path: String = "res://MainMenu/main_menu.tscn"

func _on_restart_button_pressed() -> void:
	get_tree().call_deferred("reload_current_scene")

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_path)
