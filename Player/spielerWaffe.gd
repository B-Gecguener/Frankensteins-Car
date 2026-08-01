extends Node3D

## Aims the turret. With a gamepad, the right stick sets a WORLD-space
## direction that's held until moved again - the turret does not turn with
## the car. With mouse + keyboard, the turret continuously points toward
## wherever the mouse cursor is in the world instead. Whichever device
## produced input most recently controls the aim.

@export var joy_deadzone: float = 0.2
@export var invert_x: bool = false   # flip if left/right feels backwards (gamepad)
@export var invert_y: bool = false   # flip if up/down feels backwards (gamepad)

@export_group("Shooting")
@export var fire_rate: float = 0.25   # seconds between shots

@onready var mount: Node3D = get_parent()
@onready var muzzle: Node3D = $Muzzle
@onready var hurtbox: HurtBox = mount.get_node("Hurtbox")

var projectile_scene: PackedScene = load("res://Objects/projectile.tscn")

var held_world_yaw: float = 0.0
var can_fire: bool = true
var aim_with_mouse: bool = true   # which device last provided aim input

func _ready() -> void:
	held_world_yaw = mount.global_rotation.y

func _input(event: InputEvent) -> void:
	# Whichever device the player actually moves takes over aiming.
	if event is InputEventMouseMotion:
		aim_with_mouse = true
	elif event is InputEventJoypadMotion \
	and (event.axis == JOY_AXIS_RIGHT_X or event.axis == JOY_AXIS_RIGHT_Y) \
	and absf(event.axis_value) > joy_deadzone:
		aim_with_mouse = false

func _physics_process(_delta: float) -> void:
	if aim_with_mouse:
		_aim_at_mouse()
	else:
		var stick := Input.get_vector("turret_left", "turret_right", "turret_up", "turret_down", joy_deadzone)
		if stick.length_squared() >= 0.0001:
			if invert_x:
				stick.x = -stick.x
			if invert_y:
				stick.y = -stick.y
			held_world_yaw = atan2(-stick.x, -stick.y)
		# else: stick is centered, keep holding the last aimed direction.

	# Continuously cancel the car's own heading so the turret keeps pointing
	# at held_world_yaw regardless of which way the car turns.
	rotation.y = wrapf(held_world_yaw - mount.global_rotation.y, -PI, PI)

	if Input.is_action_pressed("shoot") and can_fire:
		fire()

func _aim_at_mouse() -> void:
	var cam := get_viewport().get_camera_3d()
	if cam == null:
		return

	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := cam.project_ray_origin(mouse_pos)
	var ray_dir := cam.project_ray_normal(mouse_pos)

	# Intersect the mouse ray with the horizontal plane at the weapon's height.
	if absf(ray_dir.y) < 0.0001:
		return
	var t := (mount.global_position.y - ray_origin.y) / ray_dir.y
	if t < 0.0:
		return

	var world_point := ray_origin + ray_dir * t
	var to_point := world_point - mount.global_position
	to_point.y = 0.0
	if to_point.length_squared() < 0.0001:
		return

	held_world_yaw = atan2(-to_point.x, -to_point.z)

func fire() -> void:
	var bullet: Projectile = projectile_scene.instantiate()
	bullet.shooter = hurtbox   # so the shot can't damage the player who fired it
	add_child(bullet)
	bullet.flight_vector = (muzzle.global_position - global_position).normalized()
	bullet.global_position = muzzle.global_position

	can_fire = false
	get_tree().create_timer(fire_rate).timeout.connect(reload)

func reload() -> void:
	can_fire = true
