extends CanvasLayer

@onready var auto: Player_1 = $".."
@onready var scrap_label: Label = $Control/scrap_label

@onready var energy_health: ProgressBar = $Control/energy_progressbar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scrap_label.text = str(auto.scrap)
	energy_health.value = auto.car_battery
