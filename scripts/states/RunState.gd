class_name RunState extends StateMachine

func _on_update(_delta: float) -> void:	
	if not player.is_on_floor() and player.coyote_timer == 0:
		send_trigger(OnGroundState.FALL)
	elif player.can_jump() and InputManager.consume_jump_buffer():
		send_trigger(OnGroundState.JUMP)
	elif InputManager.is_move_pressed():
		player.perform_move(InputManager.get_move_input())
	else: 
		send_trigger(OnGroundState.IDLE)
