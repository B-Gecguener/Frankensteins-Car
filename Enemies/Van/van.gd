extends Turret

@onready var explosion_sprite: AnimatedSprite3D = $ExplosionSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(audio_player)
	audio_player.stream = kaboom
	hurtbox.died.connect(explode)
	hurtbox.car_battery = 50.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func explode():
	if not ruined:
		audio_player.play()
		explosion_sprite.play("explosion")
		turret.active = false
		ruined = true
		
		get_tree().create_timer(0.8).timeout.connect(ruin_turret)
		#explo_sprite.animation_finished.disconnect(explode)
