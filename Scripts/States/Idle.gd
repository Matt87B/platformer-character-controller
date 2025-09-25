extends StateMachine

func _on_enter() -> void:
	print("Entered Idle")

func _on_exit() -> void:
	print("Exited Idle")

func _on_update() -> void:
	print("Updated Idle")
