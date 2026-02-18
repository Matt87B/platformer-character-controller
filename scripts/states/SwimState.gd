class_name SwimState extends StateMachine

## Auto-generated StateMachine stub

func _on_update(delta: float) -> void:
	var input_dir = Input.get_axis("move_left", "move_right")
	var jump_pressed = Input.is_action_pressed("jump")
	
	#Horizontal swim velocity
	player.velocity.x = player.speed * player.swim_speed_dampening_factor * input_dir
	
	#Vertical underwater velocity
	if jump_pressed:
		player.velocity.y -= player.speed * delta * 5
	else:
		player.velocity.y += player.speed * player.swim_speed_dampening_factor * delta
		player.velocity.y = min(
			player.terminal_velocity/2 * player.swim_speed_dampening_factor,
			player.velocity.y
			)
			
