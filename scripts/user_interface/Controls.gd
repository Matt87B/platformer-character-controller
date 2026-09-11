extends Control

signal navigate_to(scene_path)
signal go_back

func _on_back_pressed() -> void:
	go_back.emit()

func _on_apply_pressed() -> void:
	pass
