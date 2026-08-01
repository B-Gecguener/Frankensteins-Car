extends Node3D

## Points the turret at whatever direction the right stick is pointing, in
## WORLD space - the turret does not turn with the car. Every frame it
## re-cancels the car's current heading against the held target so the aim
## direction stays fixed in the world even while the car spins around it.

@export var joy_deadzone: float = 0.2
@export var invert_x: bool = false   # flip if left/right feels backwards
@export var invert_y: bool = false   # flip if up/down feels backwards

@export_group("Shooting")
@export var fire_rate: float = 0.25   # seconds between shots

@onready var mount: Node3D = get_parent()
@onready var muzzle: Node3D = $Muzzle
@onready var hurtbox: HurtBox = mount.get_node("Hurtbox")

var projectile_scene: PackedScene = load("res://Objects/projectile.tscn")

var held_world_yaw: float = 0.0
var can_fire: bool = true

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

	if Input.is_action_pressed("shoot") and can_fire:
		fire()

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
