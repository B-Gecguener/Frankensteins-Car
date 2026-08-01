extends Area3D
class_name HitBox

var damage: float = 10.0
signal hit

func _on_area_entered(area: Area3D) -> void:
	if area is HurtBox:
		area.damage(damage)
		hit.emit()
