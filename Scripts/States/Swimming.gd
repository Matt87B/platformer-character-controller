extends PlayerState

func enter(previous_state_path: String) -> void:
	player.velocity = player.velocity * 0.5
	pass
	#Swimming animation here

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("move_left", "move_right")
	player.velocity.x = player.speed * player.swim_speed_dampening_factor * input_direction_x * delta
	player.velocity.y = player.gravity * player.swim_speed_dampening_factor * delta
	player.move_and_slide()
	
	
	
