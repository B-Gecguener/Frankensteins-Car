extends Area3D

@export var popup: Control

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	popup.hide() # make sure it starts hidden

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		popup.show()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		popup.hide()
