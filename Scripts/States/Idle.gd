extends PlayerState

func enter(previous_state_path: String) -> void:
	player.velocity.x = 0.0
	#Idle animation here

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	if !player.is_on_floor():
		transition_requested.emit("fall")
	elif Input.is_action_just_pressed("jump"):
		transition_requested.emit("jump")
	elif Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		transition_requested.emit("run")
