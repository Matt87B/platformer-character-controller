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
		if Input.is_action_just_pressed("jump"):
			send_trigger(player.JUMP)
		elif is_equal_approx(input_dir, 0.0):
			send_trigger(player.IDLE)
		else:
			send_trigger(player.RUN)
