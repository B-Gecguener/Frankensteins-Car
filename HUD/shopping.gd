extends CanvasLayer

@onready var button_schild: Sprite2D = $Control/TankstelleSchildButton
@onready var button_schild_2: Sprite2D = $Control/TankstelleSchildButton2
@onready var Katsching: AudioStreamPlayer = $Katsching
var player: Player_1


func _on_button_pressed() -> void:
	if player.scrap >= 5:
		player.scrap -= 5
		player.gun.upgrade()
		player.hurtbox.health_changed.emit(player.hurtbox.car_battery, player.hurtbox.max_car_battery)
		button_schild.modulate = Color(0.164, 0.336, 0.156, 1.0)
		Katsching.play()
	else:
		button_schild.modulate = Color(0.535, 0.089, 0.083, 1.0)
	button_schild.visible = true
	get_tree().create_timer(0.5).timeout.connect(reset_modulate.bind(button_schild))

func _on_button_2_pressed() -> void:
	if player.scrap >= 5:
		player.scrap -= 5
		player.hurtbox.upgrade()
		player.hurtbox.health_changed.emit(player.hurtbox.car_battery, player.hurtbox.max_car_battery)
		button_schild_2.modulate = Color(0.164, 0.336, 0.156, 1.0)
		Katsching.play()
	else:
		button_schild_2.modulate = Color(0.535, 0.089, 0.083, 1.0)
	button_schild_2.visible = true
	get_tree().create_timer(0.5).timeout.connect(reset_modulate.bind(button_schild_2))

func reset_modulate(button: Sprite2D) -> void:
	button.modulate = Color(1,1,1)
	button.visible = false
