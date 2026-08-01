extends Area3D
class_name HurtBox

@export var max_car_battery := 100
var car_battery: float = 100.0

signal died
signal health_changed(current: float, max: float)

func heal(amount: float) -> void:
	car_battery = min(max_car_battery, car_battery+amount)
	health_changed.emit(car_battery, max_car_battery)

func damage(dmg: float) -> void:
	car_battery -= dmg
	health_changed.emit(car_battery, max_car_battery)
	if car_battery <= 0:
		died.emit()

func _ready() -> void:
	car_battery = max_car_battery
	health_changed.emit(car_battery, max_car_battery)
