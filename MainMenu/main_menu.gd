extends Control

## The game scene is referenced by UID rather than by path on purpose: the
## file name "wüste.tscn" contains an umlaut that is stored on disk in a
## different Unicode normalisation than a typed string literal uses, so a
## path like "res://wüste.tscn" would not always resolve. The UID is stable
## and encoding-proof. (Renaming the scene to "wueste.tscn" would let you use
## a normal path here instead.)
@export var game_scene_uid: String = "uid://d4nkcgmjgirl5"

func _ready() -> void:
	# Arriving here from the death screen leaves the tree paused - clear it so
	# the menu (and the next run) behave normally.
	get_tree().paused = false

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_uid)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
