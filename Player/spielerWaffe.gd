extends Node3D

## Points the turret at whatever direction the right stick is pointing, in
## WORLD space - the turret does not turn with the car. Every frame it
## re-cancels the car's current heading against the held target so the aim
## direction stays fixed in the world even while the car spins around it.

@export var joy_deadzone: float = 0.2
@export var invert_x: bool = false   # flip if left/right feels backwards
@export var invert_y: bool = false   # flip if up/down feels backwards

@onready var mount: Node3D = get_parent()

var held_world_yaw: float = 0.0

func _ready() -> void:
	held_world_yaw = mount.global_rotation.y

func _physics_process(_delta: float) -> void:
	var stick := Input.get_vector("turret_left", "turret_right", "turret_up", "turret_down", joy_deadzone)

	if stick.length_squared() >= 0.0001:
		if invert_x:
			stick.x = -stick.x
		if invert_y:
			stick.y = -stick.y
		held_world_yaw = atan2(-stick.x, -stick.y)

	# Continuously cancel the car's own heading so the turret keeps pointing
	# at held_world_yaw regardless of which way the car turns.
	rotation.y = wrapf(held_world_yaw - mount.global_rotation.y, -PI, PI)
