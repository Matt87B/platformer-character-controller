extends Area2D

@export var is_start_checkpoint: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if is_start_checkpoint:
		GameStateManager.register_checkpoint(global_position)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameStateManager.register_checkpoint(global_position)
		#TODO: Add any checkpoint SFX or other things here
