extends Node3D
class_name Gun

var gun_tier: int = 0

@export var joy_deadzone: float = 0.2
@export var invert_x: bool = false
@export var invert_y: bool = false

@export_group("Shooting")
@export var fire_rate: float = 0.25

@onready var mount: Node3D = get_parent()
@onready var muzzle: Node3D = $Muzzle
@onready var hurtbox: HurtBox = mount.get_node("Hurtbox")

var projectile_scene: PackedScene = load("res://Objects/projectileVan.tscn")

var held_world_yaw: float = 0.0
var can_fire: bool = true
var aim_with_mouse: bool = true  

func _ready() -> void:
	held_world_yaw = mount.global_rotation.y

func _input(event: InputEvent) -> void:
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
	bullet.hit_box.damage = 10 + gun_tier * 5

	can_fire = false
	var reload_time: float = fire_rate
	for i in range(gun_tier):
		reload_time *= 0.8
	get_tree().create_timer(reload_time).timeout.connect(reload)

func reload() -> void:
	can_fire = true

func upgrade():
	gun_tier += 1;
