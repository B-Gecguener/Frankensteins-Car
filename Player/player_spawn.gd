extends Node3D

var player_scene: PackedScene = load("res://Player/auto.tscn")

func _ready() -> void:
	get_tree().create_timer(0.1).timeout.connect(spawn)

func spawn():
	var player: Player_1 = player_scene.instantiate()
	get_parent().add_child(player)
	player.global_position = global_position
	player.ready.connect(set_player_data.bind(player))

func set_player_data(player: Player_1):
	Levelmanager.set_player(player)
