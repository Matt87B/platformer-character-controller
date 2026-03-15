extends Node

@onready var ui_stack = $UI/UIStack

func _ready() -> void:
	SceneStack.initialize(ui_stack)
	SceneStack.push("res://scenes/main_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not SceneStack.peek():
			LevelContainer.current_level.get_tree().paused = true
			SceneStack.push("res://scenes/pause_menu.tscn")
