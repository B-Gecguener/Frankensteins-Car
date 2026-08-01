extends Node3D

## Sits on the car (Waffe1 mesh). Turns left/right on its own Y axis
## using the right stick, independent of the car's own heading.

@export var turn_speed: float = 3.0        # rad/s, max traverse speed at full stick deflection
@export var turn_acceleration: float = 12.0 # rad/s^2, how fast it ramps up/slows down
@export var invert: bool = false            # flip this if the turret turns the wrong way

var current_speed: float = 0.0

func _physics_process(delta: float) -> void:
	var aim := Input.get_axis("turret_left", "turret_right")
	if invert:
		aim = -aim

	var target_speed := aim * turn_speed
	current_speed = move_toward(current_speed, target_speed, turn_acceleration * delta)

	rotation.y -= current_speed * delta
