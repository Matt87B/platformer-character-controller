class_name RunState extends StateMachine

func _on_enter() -> void:
	print("Entered RunState")

func _on_exit() -> void:
	print("Exited RunState")

func _on_update(_delta: float) -> void:
	var input_dir = Input.get_axis("move_left", "move_right")
	
	if not player.is_on_floor():
		send_trigger(player.FALL)
	elif player.jump_buffer_timer > 0 and player.coyote_timer > 0:
		send_trigger(player.JUMP)
	elif input_dir != 0:
		player.velocity.x = input_dir * player.speed
	else: 
		send_trigger(player.IDLE)
