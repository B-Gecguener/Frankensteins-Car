extends Node3D

func _ready() -> void:
	get_tree().create_timer(0.1).timeout.connect(spawn)

func spawn():
	get_parent().add_child(Levelmanager.get_player())
	Levelmanager.get_player().global_position = global_position
