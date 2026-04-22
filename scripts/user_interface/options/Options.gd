extends Control

signal navigate_to(scene_path)
signal go_back

func _on_back_pressed() -> void:
	go_back.emit()

func _on_controls_pressed() -> void:
	navigate_to.emit(GameStateManager.SCENE_CONTROLS)
	
func _on_sound_pressed() -> void:
	navigate_to.emit(GameStateManager.SCENE_SOUND)
	
func _on_video_pressed() -> void:
	navigate_to.emit(GameStateManager.SCENE_VIDEO)
