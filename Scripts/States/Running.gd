extends PlayerState

func enter(previous_state_path: String) -> void:
	pass
	#Running animation here

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * input_direction_x * delta
	player.velocity.y = player.gravity * delta
	player.move_and_slide()
	
	if !player.is_on_floor():
		transition_requested.emit("fall")
	elif Input.is_action_just_pressed("jump"):
		transition_requested.emit("jump")
	elif is_equal_approx(input_direction_x, 0.0):
		transition_requested.emit("stop")
