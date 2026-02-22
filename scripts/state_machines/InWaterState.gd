class_name InWaterState extends StateMachine

@export var buoyancy := 600.0
@export var swim_force := 1200.0

@export var vertical_drag := 8.0
@export var horizontal_drag := 14.0

@export var water_speed := 900.0

@export var max_swim_speed := 160.0

func _on_enter() -> void:
	var x = clamp(abs(player.velocity.x) / 600.0, 0.0, 1.0)
	var y = clamp(abs(player.velocity.y) / 800.0, 0.0, 1.0)
	var dampening = lerp(0.7, 0.9, Vector2(x, y))
	player.velocity *= dampening

func _on_update(delta: float) -> void:
	var vertical_force := 0.0
	var horizontal_force := 0.0
	var input_dir = Input.get_axis("move_left", "move_right")
	
	vertical_force += player.gravity
	vertical_force -= buoyancy
	horizontal_force = input_dir * water_speed
	
	if Input.is_action_pressed("jump"):
		vertical_force -= swim_force
	
	#Apply drag
	vertical_force -= vertical_drag * player.velocity.y
	horizontal_force -= horizontal_drag * player.velocity.x
	
	#Apply forces
	player.velocity.y += vertical_force * delta
	player.velocity.x += horizontal_force * delta
	
	if not player.is_in_water:
		player.velocity.y *= 2
		send_trigger(MovementStateMachine.GROUND)
