extends Node3D
class_name Turret

@onready var hurtbox: HurtBox = $Hurtbox
@onready var explo_sprite: AnimatedSprite3D = $ExplosionSprite
@onready var turret_sprite: AnimatedSprite3D = $TurretSprite
@onready var turret: Node3D = $Cannon

var pickup: PackedScene = load("res://Objects/pickup.tscn")
var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
var kaboom: AudioStream = load("res://Sound/Kaboom.mp3")
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var ruined: bool = false

var velocity: Vector3 = Vector3(0,-1,0);

# Called when the node edefault_2nters the scene tree for the first time.
func _ready() -> void:
	add_child(audio_player)
	audio_player.stream = kaboom
	#explo_sprite.animation_finished.connect(ruin_turret)
	hurtbox.died.connect(explode)
	#get_tree().create_timer(3.0).timeout.connect(explode)


func explode():
	if not ruined:
		audio_player.play()
		turret.active = false
		ruined = true
		explo_sprite.play("explosion")
		get_tree().create_timer(0.8).timeout.connect(ruin_turret)
		#explo_sprite.animation_finished.disconnect(explode)

func ruin_turret():
	if turret:
		turret.queue_free()
	turret_sprite.play("ruined")
	spawn_drops()

func spawn_drops():
	var batterie_amount: int = rng.randi_range(0,1)+2
	var scrap_avanmount: int = 4-batterie_amount
	
	var drop_dir: Vector3 = Vector3(1,0,0)
	
	for i in range(4):
		var pickup: Pickup = pickup.instantiate()
		if i <= batterie_amount-1:
			pickup.pickup_kind = pickup.pickupKind.batterie
		else:
			pickup.pickup_kind = pickup.pickupKind.scrap
		add_child(pickup)
		pickup.global_position = Vector3(global_position.x, 0, global_position.z) + drop_dir.rotated(Vector3(0,1,0),i*30)*2
