extends AnimatedSprite3D

@export var hurtbox: HurtBox
var timer: Timer = Timer.new()

func _ready() -> void:
	timer.wait_time = 0.2
	if hurtbox:
		hurtbox.damaged.connect(blink)
	timer.timeout.connect(reset)

func blink():
	print("blink")
	modulate = Color(1.0, 0.0, 0.0, 1.0)
	timer.start()

func reset():
	print("reset")
	modulate = Color(1.0, 1.0, 1.0, 1.0)
