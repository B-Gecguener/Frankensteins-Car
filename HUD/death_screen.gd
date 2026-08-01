extends Control

## Scenes are referenced by PATH, not as PackedScene resources. The HUD lives
## inside the player, which lives inside the game scene, so holding a
## PackedScene of the menu here would create a load cycle
## (HUD -> menu -> game world -> player -> HUD) that Godot cannot resolve.

@export_file("*.tscn") var main_menu_path: String = "res://MainMenu/main_menu.tscn"

func _on_restart_button_pressed() -> void:
	# Stay paused: the scene change is deferred to the end of the frame, and
	# unpausing now would let the old world run (and kill the player again)
	# before the swap happens. The new scene unpauses itself in hud.gd.
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_path)
