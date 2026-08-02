extends Area3D
class_name HurtBox

@export var additional_max_battery_per_tier: float = 25.0

@export var max_car_battery: float = 100.0
var car_battery: float = 100.0

var battery_tier: int = 0

signal died
signal damaged
signal health_changed(current: float, max: float)

func _ready() -> void:
	max_car_battery = 100 + additional_max_battery_per_tier * battery_tier
	health_changed.emit(car_battery, max_car_battery)

func use(amount: float) -> void:
	car_battery -= amount
	health_changed.emit(car_battery, max_car_battery)
	if car_battery <= 0:
		died.emit()

func heal(amount: float) -> void:
	car_battery = min(max_car_battery, car_battery+amount)
	health_changed.emit(car_battery, max_car_battery)

func damage(dmg: float) -> void:
	car_battery -= dmg
	health_changed.emit(car_battery, max_car_battery)
	if car_battery <= 0:
		died.emit()
	damaged.emit()

func upgrade():
	battery_tier += 1
	var change: float = battery_tier * additional_max_battery_per_tier
	max_car_battery += change
	car_battery += change
	health_changed.emit(car_battery, max_car_battery)

func set_data(bat_tier: int, curr_battery: float):
	battery_tier = bat_tier
	car_battery = curr_battery
	max_car_battery = 100 + additional_max_battery_per_tier * battery_tier
	health_changed.emit(car_battery, max_car_battery)
