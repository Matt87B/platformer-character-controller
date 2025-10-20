class_name JumpState extends StateMachine

func _on_enter() -> void: 
	print("Entered JumpState")
	player.velocity.y = -player.jump_impulse

func _on_exit() -> void:
	print("Exited JumpState")

func _on_update(delta: float) -> void:
	if player.is_on_floor():
		send_trigger(player.IDLE)
	else:
		send_trigger(player.FALL)
		
