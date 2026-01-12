class_name FallState extends StateMachine

func _on_enter() -> void: 
	print("Entered FallState")

func _on_exit() -> void:
	print("Exited FallState")

func _on_update(delta: float) -> void:
	var input_dir = Input.get_axis("move_left", "move_right")
	
	player.velocity.y += player.gravity * delta
	player.velocity.x = player.speed * input_dir

	if player.is_on_floor():
		if is_equal_approx(input_dir, 0.0):
			send_trigger(player.IDLE)
		else:
			send_trigger(player.RUN)
	elif player.is_on_wall_only() and input_dir != 0:
		send_trigger(player.WALL)
