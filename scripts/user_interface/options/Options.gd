extends Control

func _on_back_pressed() -> void:
	SceneStack.pop()

func _on_controls_pressed() -> void:
	print("Pressed controls")

func _on_sound_pressed() -> void:
	print("Pressed sound")

func _on_video_pressed() -> void:
	print("Pressed video")
