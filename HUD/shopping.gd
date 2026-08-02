extends CanvasLayer

@onready var button_schild: Sprite2D = $Control/TankstelleSchildButton
@onready var button_schild_2: Sprite2D = $Control/TankstelleSchildButton2


func _on_button_pressed() -> void:
	button_schild.visible = true

func _on_button_2_pressed() -> void:
	button_schild_2.visible = true
