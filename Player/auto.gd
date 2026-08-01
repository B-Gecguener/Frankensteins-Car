extends CharacterBody3D
class_name Player_1

@export var engine_power := 5.0
@export var braking_power := 45.0

@export var max_speed := 18.0
@export var max_speed_reverse := 10.0

@export var steering_speed := 0.7     # Wie schnell das Auto lenkt
@export var friction := 10.0
@export var drag := 0.15

@export var scrap := 0

@onready var collection_area: CollectionArea = $CollectionArea
@onready var hurtbox: HurtBox = $Hurtbox

var throttle := 0.0
var car_battery = 100

func _ready() -> void:
	collection_area.scrap.connect(add_scrap)
	collection_area.power.connect(add_power)

func add_scrap(amount: int):
	scrap += amount
	
func add_power(amount: int):
	hurtbox.heal(amount)

func _physics_process(delta):

	# -----------------------------
	# Beschleunigung
	# -----------------------------

	throttle = 0.0

	var gas := Input.get_action_strength("accelerate")   # analog on L2, digital (1.0) on W
	if gas > 0.0:
		throttle = gas
	elif Input.is_action_pressed("decelerate"):
		throttle = -1.0

	var forward = -transform.basis.z

	if throttle > 0:
		velocity += forward * engine_power * delta

	elif throttle < 0:
		velocity -= forward * braking_power * delta


	# -----------------------------
	# Lenkung
	# -----------------------------

	var steer = Input.get_axis("steer_left", "steer_right")

	# Geschwindigkeit entlang der Fahrzeugrichtung
	var forward_speed = velocity.dot(forward)

	# Beim Rückwärtsfahren Lenkung invertieren
	#if forward_speed < -0.1:
	#	steer *= -1.0

	# Nur lenken wenn sich das Auto bewegt
	if abs(forward_speed) > 0.2:
		rotate_y(-steer * steering_speed * delta)

	# -------------------------------------------------
	# Reifen-Grip
	# -------------------------------------------------

	forward = -transform.basis.z

	var speed = velocity.length()

	# Bei niedriger Geschwindigkeit fast voller Grip,
	# bei hoher Geschwindigkeit beginnt das Auto zu driften.
	var grip: float

	if speed < 10.0:
		grip = 12.0
	elif speed < 16.0:
		grip = 6.0
	else:
		grip = 2.0

	if speed > 0.01:
		var desired_velocity = forward * speed
		velocity = velocity.lerp(desired_velocity, grip * delta)


	# -----------------------------
	# Reibung
	# -----------------------------

	if throttle == 0.0:
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)

	velocity -= velocity * drag * delta


	# -----------------------------
	# Maximalgeschwindigkeit
	# -----------------------------

	forward = -transform.basis.z
	forward_speed = velocity.dot(forward)

	var side = velocity - forward * forward_speed

	if forward_speed > max_speed:
		forward_speed = max_speed

	if forward_speed < -max_speed_reverse:
		forward_speed = -max_speed_reverse

	velocity = forward * forward_speed + side
	
	hurtbox.use(velocity.length() / max_speed * delta * 4)


	# Nur X/Z bewegen
	velocity.y = 0

	move_and_slide()
