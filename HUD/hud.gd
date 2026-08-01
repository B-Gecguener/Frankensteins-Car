extends CanvasLayer

@onready var auto: Player = $"."
@onready var label: Label = $Control/Label
@onready var progress_bar: ProgressBar = $Control/ProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = str(auto.battery) + "/" + str(auto.max_car_battery)
