extends Node

func _ready():
	GameStateManager.call_deferred("go_to_main_menu")
