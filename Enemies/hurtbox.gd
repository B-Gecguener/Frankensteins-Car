extends Area3D
class_name HurtBox

@export var health: float = 100.0
signal died

func damage(dmg: float) -> void:
	health -= dmg
	if health <= 0:
		died.emit()
