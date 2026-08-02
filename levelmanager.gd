extends Node

var auto: PackedScene = load("res://Player/auto.tscn")
var player: Player_1

func _ready() -> void:
	player = auto.instantiate()

func get_player() -> Player_1:
	return player

func save_player(player_: Player_1):
	player = player_
