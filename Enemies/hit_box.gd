extends Area3D
class_name HitBox

@export var damage: float = 3.0
var shooter: HurtBox = null
signal hit

func _on_area_entered(area: Area3D) -> void:
	if area is HurtBox and area != shooter:
		area.damage(damage)
		hit.emit()
