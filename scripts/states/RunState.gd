class_name RunState extends StateMachine

func _on_update(_delta: float) -> void:
	var input_dir = Input.get_axis("move_left", "move_right")
	
	if not player.is_on_floor() and player.coyote_timer == 0:
		send_trigger(OnGroundState.FALL)
	elif player.jump_buffer_timer > 0 and player.coyote_timer > 0 and player.jump_cooldown_timer == 0:
		send_trigger(OnGroundState.JUMP)
	elif input_dir != 0:
		player.velocity.x = input_dir * player.speed
	else: 
		send_trigger(OnGroundState.IDLE)
