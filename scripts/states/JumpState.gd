class_name JumpState extends StateMachine

func _on_enter() -> void: 
	print("Entered JumpState")
	player.jump_cooldown_timer = player.jump_cooldown
	player.velocity.y = -player.jump_impulse

func _on_exit() -> void:
	print("Exited JumpState")

func _on_update(delta: float) -> void:
	var input_dir = Input.get_axis("move_left", "move_right")
	
	player.velocity.x = player.speed * input_dir
	player.velocity.y += player.gravity * delta
	
	if player.is_on_floor():
		send_trigger(player.IDLE)
	elif Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y *= player.jump_cut_mult * delta
	elif player.is_on_wall_only() and input_dir != 0:
		send_trigger(player.WALL)
