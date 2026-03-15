extends Control

func _on_play_pressed() -> void:
	SceneStack.pop()
	LevelContainer.load_level("res://scenes/node_2d.tscn")

func _on_load_pressed() -> void:
	print("Pressed load.")

func _on_options_pressed() -> void:
	SceneStack.push("res://scenes/options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
