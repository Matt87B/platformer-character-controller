extends Control

signal navigate_to(scene_path)
signal go_back

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_resume_pressed() -> void:
	GameStateManager.resume_game()

func _on_options_pressed() -> void:
	emit_signal("navigate_to", "res://scenes/user_interface/options.tscn")
	
func _on_save_and_exit_pressed() -> void:
	GameStateManager.save_and_exit_to_menu()
