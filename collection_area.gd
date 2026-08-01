extends Area3D

signal power(amount: int)
signal scrap(amount: int)

func _on_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if area is Batterie:
		area.queue_free()
		power.emit(20)
	if area is Scrap:
		area.queue_free()
		scrap.emit(1)
