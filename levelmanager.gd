extends Node

class PlayerData:
	var current_battery: float = 100.0
	var scrap: int = 0
	var gun_tier: int = 0
	var battery_tier: int = 0

var player_data: PlayerData = PlayerData.new()

func reset_all():
	player_data = PlayerData.new()

func set_player(player: Player_1):
	player.scrap = player_data.scrap
	player.hurtbox.set_data(player_data.battery_tier, player_data.current_battery)
	player.gun.gun_tier = player_data.gun_tier

func save_player(player: Player_1):
	player_data.battery_tier = player.hurtbox.battery_tier
	player_data.current_battery = player.hurtbox.car_battery
	player_data.scrap = player.scrap
	player_data.gun_tier = player.gun.gun_tier
