extends PlayerState

func enter(previous_state_path: String):
	player.velocity.y = player.jump_impulse
	#Jump animated here

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x * delta
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if player.velocity.y >= 0:
		transition_requested.emit("fall")
