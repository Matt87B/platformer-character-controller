extends Control

signal navigate_to(scene_path)

func _on_play_pressed() -> void:
	GameStateManager.start_game(GameStateManager.LEVEL_1)

func _on_load_pressed() -> void:
	navigate_to.emit(GameStateManager.SCENE_LOAD)

func _on_options_pressed() -> void:
	navigate_to.emit(GameStateManager.SCENE_OPTIONS)

func _on_quit_pressed() -> void:
	GameStateManager.quit_game()
