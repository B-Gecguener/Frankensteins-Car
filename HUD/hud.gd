extends CanvasLayer

@onready var auto: Player_1 = $".."
@onready var hurtbox: HurtBox = $"../Hurtbox"  # adjust path
@onready var scrap_label: Label = $Control/scrap_label
@onready var energy_health: ProgressBar = $Control/energy_progressbar

func _ready() -> void:
	energy_health.max_value = hurtbox.max_car_battery
	hurtbox.health_changed.connect(_on_health_changed)

func _on_health_changed(current: float, max: float) -> void:
	energy_health.value = current

func _process(delta: float) -> void:
	scrap_label.text = str(auto.scrap)
