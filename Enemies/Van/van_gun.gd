extends Node3D

@export var car: CharacterBody3D
@export var turret: Node3D   # yaws around Y

@onready var detection_area: Area3D = $Area3D
@onready var muzzle: Node3D = $turret/cannon/Muzzle

var projectile: PackedScene = load("res://Objects/projectile.tscn")

@export_group("Aiming")
@export var max_yaw_speed: float = 7       # rad/s, top traverse speed
@export var yaw_accel: float = 10            # rad/sÂ², lower = more momentum
@export var tracking_gain: float = 8.0       # how aggressively it closes the error

var yaw_speed: float = 0.0
var target: Vector3 = Vector3.ZERO

var loaded: bool = true
var active: bool = true

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var randomness: Vector3 = Vector3(rng.randf_range(0.0,3.0),0,rng.randf_range(0.0,3.0))

func _ready() -> void:
	_recalc_randomness()

func _recalc_randomness() -> void:
	get_tree().create_timer(1.0,false,true,false).timeout.connect(_recalc_randomness)
	randomness = Vector3(rng.randf_range(0.0,8.0),0,rng.randf_range(0.0,8.0))

func _physics_process(delta: float) -> void:
	if active:
		var desired_yaw_speed: float = 0.0
		var desired_pitch_speed: float = 0.0

		if car:
			var speed: float = car.velocity.length()*delta
			var vorhalt: Vector3 = (-car.transform.basis.z) * speed * global_position.distance_to(car.global_position) *3
			
			var target = car.global_position + vorhalt + (randomness * speed)

			var yaw_error: float = angle_difference(turret.rotation.y, _target_yaw(target))
			
			desired_yaw_speed = clampf(yaw_error * tracking_gain, -max_yaw_speed, max_yaw_speed)
	
			if loaded:
					fire()
					
		# momentum: angular velocity can only change at a limited rate
		yaw_speed = move_toward(yaw_speed, desired_yaw_speed, yaw_accel * delta)
		turret.rotation.y = wrapf(turret.rotation.y + yaw_speed * delta, -PI, PI)

func fire() -> void:
	var bullet: Projectile = projectile.instantiate()
	add_child(bullet)
	bullet.flight_vector = (muzzle.global_basis.z).normalized()
	bullet.global_position = muzzle.global_position
	loaded = false
	get_tree().create_timer(0.5).timeout.connect(reload)

func reload() -> void:
	loaded = true

func _target_yaw(point: Vector3) -> float:
	# convert into the turret's parent space so the mount's own rotation is accounted for
	var local: Vector3 = turret.get_parent().to_local(point)
	return atan2(-local.x, -local.z)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player_1:
		car = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	for dect_body in detection_area.get_overlapping_bodies():
		if dect_body is Player_1:
			return
	car = null
