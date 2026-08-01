extends Area3D
class_name Pickup

var player: Player_1
var velocity: Vector3

enum pickupKind {
	scrap,
	batterie,
}

@export var pickup_kind: pickupKind = pickupKind.scrap
@onready var dect_area: Area3D = $Area3D
@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D

func _ready() -> void:
	if pickup_kind == pickupKind.scrap: sprite.play("scrap")
	if pickup_kind == pickupKind.batterie: sprite.play("batterie")

func _physics_process(delta: float) -> void:
	if player:
		velocity = global_position.direction_to(player.global_position)*600 * delta 
		global_position += velocity * delta
	if global_position.y > 0:
		velocity += Vector3(0,-1,0);
		global_position += velocity
	else: 
		velocity.y = 0

func body_entered(body: Node3D) -> void:
	if body is Player_1:
		player = body
