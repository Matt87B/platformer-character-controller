class_name FallState extends StateMachine

func _on_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	player.velocity.y = min(player.terminal_velocity, player.velocity.y)
	
	player.perform_move(InputManager.get_move_input())

	if player.is_on_floor():
		if not InputManager.is_move_pressed():
			send_trigger(OnGroundState.IDLE)
		else:
			send_trigger(OnGroundState.RUN)
	elif player.can_wall_slide():
		send_trigger(OnGroundState.WALL)
