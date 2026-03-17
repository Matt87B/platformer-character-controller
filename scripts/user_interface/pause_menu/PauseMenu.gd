extends Control


func _on_options_pressed() -> void:
	SceneStack.push("res://scenes/user_interface/options.tscn")

func _on_resume_pressed() -> void:
	LevelContainer.current_level.get_tree().paused = false
	SceneStack.pop()

func _on_save_and_exit_pressed() -> void:
	LevelContainer.current_level.get_tree().paused = false
	LevelContainer.unload_level()
	SceneStack.pop()
	SceneStack.push("res://scenes/user_interface/main_menu.tscn")
