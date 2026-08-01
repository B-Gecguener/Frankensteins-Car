extends Node3D
class_name Turret

@onready var hurtbox: HurtBox = $Hurtbox
@onready var explo_sprite: AnimatedSprite3D = $ExplosionSprite
@onready var turret_sprite: AnimatedSprite3D = $TurretSprite
@onready var turret: Node3D = $Cannon

var scrap: PackedScene = load("res://Objects/scrap.tscn")
var batterie: PackedScene = load("res://Objects/batterie.tscn")

var velocity: Vector3 = Vector3(0,-1,0);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explo_sprite.animation_finished.connect(ruin_turret)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if global_position.y >= 0:
		velocity += Vector3(0,-1,0);
		global_position += velocity
	else: 
		velocity.y = 0

func explode():
	explo_sprite.play("explosion")

func ruin_turret():
	turret.queue_free()
	turret_sprite.play("ruined")

func spawn_drops():
	pass
