class_name FallState extends StateMachine

func _on_update(delta: float) -> void:
	var input_dir = Input.get_axis("move_left", "move_right")
	
	player.velocity.y += player.gravity * delta
	player.velocity.y = min(player.terminal_velocity, player.velocity.y)
	
	player.velocity.x = player.speed * input_dir

	if player.is_on_floor():
		if is_equal_approx(input_dir, 0.0):
			send_trigger(OnGroundState.IDLE)
		else:
			send_trigger(OnGroundState.RUN)
	elif player.is_on_wall_only() and input_dir != 0:
		send_trigger(OnGroundState.WALL)
