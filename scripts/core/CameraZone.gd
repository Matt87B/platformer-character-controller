extends Area2D

@export var camera: Camera2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and camera:
		var shape := $CollisionShape2D.shape as RectangleShape2D
		var rect := Rect2(global_position - shape.size / 2.0, shape.size)
		camera.set_bounds(rect)
