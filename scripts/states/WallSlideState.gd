class_name WallSlideState extends StateMachine

## Auto-generated StateMachine stub

func _on_enter() -> void: 
	print("Entered WallSlideState")
	player.velocity.y = 0

func _on_exit() -> void:
	print("Exited WallSlideState")

func _on_update(delta: float) -> void:
	
	var input_dir = Input.get_axis("move_left", "move_right")
	
	player.velocity.y += (player.gravity * player.wall_slide_factor) * delta
	player.velocity.x = player.speed * input_dir
	
	if not player.is_on_wall_only():
		send_trigger(player.FALL)
