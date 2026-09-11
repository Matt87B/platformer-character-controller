extends Control

signal navigate_to(scene_path)

func _on_resume_pressed() -> void:
	GameStateManager.resume_game()

func _on_options_pressed() -> void:
	navigate_to.emit(GameStateManager.SCENE_OPTIONS)
	
func _on_save_and_exit_pressed() -> void:
	GameStateManager.save_and_exit_to_menu()
