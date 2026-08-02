extends CanvasLayer

@onready var auto: Player_1 = $".."
@onready var hurtbox: HurtBox = $"../Hurtbox"  # adjust path
@onready var scrap_label: Label = $Control/scrap_label
@onready var energy_health: ProgressBar = $Control/energy_progressbar
@onready var death_screen: Control = $DeathScreen

var is_dead: bool = false

func _ready() -> void:
	# The tree is still paused when arriving here from the death screen's
	# Restart button, so clear it for the fresh run.
	get_tree().paused = false

	energy_health.max_value = hurtbox.max_car_battery
	hurtbox.health_changed.connect(_on_health_changed)
	hurtbox.died.connect(_on_player_died)

func _on_health_changed(current: float, max: float) -> void:
	energy_health.value = current

func _on_player_died() -> void:
	# died can fire more than once if further damage lands in the same frame.
	if is_dead:
		return
	is_dead = true

	death_screen.visible = true
	get_tree().paused = true

func _process(delta: float) -> void:
	scrap_label.text = str(auto.scrap)
	
var popup: Control

func show_popup() -> void:
	if popup:
		popup.show()

func hide_popup() -> void:
	if popup:
		popup.hide()
