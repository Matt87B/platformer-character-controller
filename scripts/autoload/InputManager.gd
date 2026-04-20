extends Node

var _move_input := 0.0

var _jump_pressed := false
var _jump_just_pressed := false
var _jump_just_released := false

var jump_buffer_time := 0.1
var _jump_buffer_timer := 0.0

func _process(delta):
	_update_movement()
	_update_jump()
	_update_buffer(delta)

#Movememt
func _update_movement():
	_move_input = Input.get_axis("move_left", "move_right")

func get_move_input() -> float:
	return _move_input

func is_move_pressed() -> bool:
	return not is_equal_approx(_move_input, 0.0)

#Jump
func _update_jump():
	_jump_just_pressed = Input.is_action_just_pressed("jump")
	_jump_just_released = Input.is_action_just_released("jump")
	_jump_pressed = Input.is_action_pressed("jump")

	if _jump_just_pressed:
		_jump_buffer_timer = jump_buffer_time

func is_jump_pressed() -> bool:
	return _jump_pressed

func is_jump_just_pressed() -> bool:
	return _jump_just_pressed

func is_jump_just_released() -> bool:
	return _jump_just_released

#Buffers/Timers
func _update_buffer(delta):
	if _jump_buffer_timer > 0:
		_jump_buffer_timer -= delta
	
##Returns true if jump buffer was consumed, false otherwise
func consume_jump_buffer() -> bool:
	if _jump_buffer_timer > 0:
		_jump_buffer_timer = 0
		return true
	return false
