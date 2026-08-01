extends Node3D
class_name Turret

@onready var hurtbox: HurtBox = $Hurtbox
@onready var explo_sprite: AnimatedSprite3D = $ExplosionSprite
@onready var turret_sprite: AnimatedSprite3D = $TurretSprite
@onready var turret: Node3D = $Cannon

var scrap: PackedScene = load("res://Objects/scrap.tscn")
var batterie: PackedScene = load("res://Objects/batterie.tscn")
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var velocity: Vector3 = Vector3(0,-1,0);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	explo_sprite.animation_finished.connect(ruin_turret)
	hurtbox.died.connect(explode)
	get_tree().create_timer(3.0).timeout.connect(explode)


func explode():
	explo_sprite.play("explosion")
	explo_sprite.animation_finished.disconnect(explode)
	#ruin_turret()

func ruin_turret():
	turret.queue_free()
	turret_sprite.play("ruined")

func spawn_drops():
	var batterie_amount: int = rng.randi_range(0,2)+1
	var scrap_amount: int = 4-batterie_amount
	
	var drop_dir: Vector3 = Vector3(0,2,0)
	
	for i in range(4):
		if i <= batterie_amount-1:
			var batterie_: Batterie = batterie.instantiate()
			batterie_.velocity = drop_dir*5
			add_child(batterie_)
		else:
			var scrap_: Scrap = scrap.instantiate()
			scrap_.velocity = drop_dir*5
			add_child(scrap_)
		drop_dir.rotated(Vector3(0,1,0), 45)
			
	
