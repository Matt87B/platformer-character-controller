class_name IdleState extends StateMachine

func _on_enter() -> void:
	player.velocity.x = 0.0
	player.velocity.y = 0.0

func _on_update(_delta: float) -> void:
	if not player.is_on_floor():
		send_trigger(OnGroundState.FALL)
	else:
		if InputManager.is_move_pressed():
			send_trigger(OnGroundState.RUN)
		elif player.can_jump() and InputManager.consume_jump_buffer():
			send_trigger(OnGroundState.JUMP)
	
