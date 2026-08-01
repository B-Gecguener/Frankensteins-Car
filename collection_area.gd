extends Area3D

signal power(amount: int)
signal scrap(amount: int)

func _on_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if area is Pickup:
		if area.pickup_kind == area.pickupKind.batterie:
			area.queue_free()
			power.emit(20)
		if area.pickup_kind == area.pickupKind.scrap:
			area.queue_free()
			scrap.emit(1)
