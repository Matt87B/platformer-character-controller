extends Control

signal navigate_to(scene_path)
signal go_back

func _on_back_pressed() -> void:
	go_back.emit()

func _on_vsync_toggled(toggled_on: bool):
	pass

func _on_apply_pressed() -> void:
	pass
