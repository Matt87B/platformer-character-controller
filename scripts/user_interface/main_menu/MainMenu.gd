extends Control

func _on_play_pressed() -> void:
	SceneStack.pop()
	LevelContainer.load_level("res://scenes/level_1.tscn")

func _on_load_pressed() -> void:
	print("Pressed load.")

func _on_options_pressed() -> void:
	SceneStack.push("res://scenes/user_interface/options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
