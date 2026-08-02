extends Area3D

const SHOPPING_SCENE := preload("res://HUD/shopping.tscn")

var _popup: CanvasLayer = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if not body is Player_1:
		return
	if _popup != null:
		return
	_popup = SHOPPING_SCENE.instantiate()
	_popup.player = body
	add_child(_popup)

func _on_body_exited(body: Node3D) -> void:
	if not body is Player_1:
		return
	if _popup == null:
		return
	_popup.queue_free()
	_popup = null
