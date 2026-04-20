class_name JumpState extends StateMachine

func _on_enter() -> void:
	player.perform_jump()

func _on_update(delta: float) -> void:
	player.perform_move(InputManager.get_move_input())
	
	player.velocity.y += player.gravity * delta
	player.velocity.y = min(player.terminal_velocity, player.velocity.y)
	
	if not Input.is_action_pressed("jump") and player.velocity.y < 0:
		player.velocity.y *= player.jump_cut_mult * delta
	
	if player.is_on_floor():
		send_trigger(OnGroundState.IDLE)
	elif player.can_wall_slide():
		send_trigger(OnGroundState.WALL)
