extends CharacterBody3D

@export var wheel_base := 2.2
@export var steering_angle := 20.0
@export var engine_power := 25.0
@export var braking := 20.0

@export var friction := -8.0
@export var drag := -0.15

@export var max_speed_reverse := 8.0
@export var slip_speed := 12.0
@export var traction_fast := 2.5
@export var traction_slow := 8.0

var acceleration := Vector3.ZERO
var steer_direction := 0.0


func _physics_process(delta):

	acceleration = Vector3.ZERO

	get_input()
	apply_friction(delta)
	calculate_steering(delta)

	velocity += acceleration * delta

	velocity.y = 0

	move_and_slide()


func get_input():

	var turn = Input.get_axis("steer_left", "steer_right")
	steer_direction = turn * deg_to_rad(steering_angle)

	# Vorwärts = -Z
	var forward = -transform.basis.z

	if Input.is_action_pressed("accelerate"):
		acceleration = forward * engine_power

	elif Input.is_action_pressed("decelerate"):
		acceleration = -forward * braking


func apply_friction(delta):

	if acceleration == Vector3.ZERO and velocity.length() < 0.1:
		velocity = Vector3.ZERO

	acceleration += velocity * friction
	acceleration += velocity * velocity.length() * drag


func calculate_steering(delta):

	if velocity.length() < 0.01:
		return

	var forward = -transform.basis.z

	var rear_wheel = global_position - forward * wheel_base * 0.5
	var front_wheel = global_position + forward * wheel_base * 0.5

	rear_wheel += velocity * delta

	front_wheel += velocity.rotated(Vector3.UP, steer_direction) * delta

	var new_heading = rear_wheel.direction_to(front_wheel)
	new_heading.y = 0
	new_heading = new_heading.normalized()

	var traction = traction_slow

	if velocity.length() > slip_speed:
		traction = traction_fast

	var d = new_heading.dot(velocity.normalized())

	if d > 0:
		velocity = velocity.lerp(new_heading * velocity.length(), traction * delta)

	elif d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	# Auto zeigt nach -Z
	look_at(global_position + new_heading, Vector3.UP)
