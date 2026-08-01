extends Node3D

## Points the turret exactly where the right stick is pointing - a full
## 360-degree match to the stick's angle, not a turn rate. Independent of
## the car's own heading, since this node just rotates on its own Y axis.

@export var joy_deadzone: float = 0.2
@export var invert_x: bool = false   # flip if left/right feels backwards
@export var invert_y: bool = false   # flip if up/down feels backwards

func _physics_process(_delta: float) -> void:
	var stick := Input.get_vector("turret_left", "turret_right", "turret_up", "turret_down", joy_deadzone)

	# Stick centered: hold the last direction instead of snapping back to 0.
	if stick.length_squared() < 0.0001:
		return

	if invert_x:
		stick.x = -stick.x
	if invert_y:
		stick.y = -stick.y

	# stick.x: right stick horizontal (right = +1)
	# stick.y: right stick vertical (down = +1, matches raw joypad axis convention)
	rotation.y = atan2(-stick.x, -stick.y)
