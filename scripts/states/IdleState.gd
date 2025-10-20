class_name IdleState extends StateMachine

func _on_enter() -> void:
	print("Entered IdleState")
	player.velocity.x = 0.0
	player.velocity.y = 0.0

func _on_exit() -> void:
	print("Exited IdleState")

func _on_update(_delta: float) -> void:
	var input_dir = Input.get_axis("move_left", "move_right")
	if not player.is_on_floor():
		send_trigger(player.FALL)
	else:
		if not is_equal_approx(input_dir, 0.0):
			send_trigger(player.RUN)
		elif Input.is_action_just_pressed("jump"):
			send_trigger(player.JUMP)
	
