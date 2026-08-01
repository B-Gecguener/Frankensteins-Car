extends Area3D

signal power(amount: int)
signal scrap(amount: int)

func _on_area_entered(area: Area3D) -> void:
	if area is Batterie:
		area.queue_free()
		power.emit(20)
	if area is Scrap:
		area.queue_free()
		scrap.emit(1)
