extends Turret

@onready var hurt_box: HurtBox = $HurtBox
@onready var explosion_sprite: AnimatedSprite3D = $ExplosionSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.died.connect(explode)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func explode():
	if not ruined:
		explosion_sprite.play("explosion")
		turret.active = false
		ruined = true
		
		get_tree().create_timer(0.8).timeout.connect(ruin_turret)
		#explo_sprite.animation_finished.disconnect(explode)
