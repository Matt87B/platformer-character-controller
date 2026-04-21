class_name Player extends CharacterBody2D

@export var speed := 100.0
@export var terminal_velocity := 200
@export var jump_impulse := 300.0
@export var min_jump_speed := 150.0
@export var coyote_time := 0.03
@export var wall_slide_factor := 0.2
@export var wall_pushback := 250
@export var jump_cooldown := 0.2
@export var jump_cut_mult := 0.90

var coyote_timer := 0.0
var jump_cooldown_timer := 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_in_water := false

@onready var movement_state_machine : StateMachine = $MovementStateMachine
@onready var status_state_machine : StateMachine = $StatusStateMachine

func _physics_process(delta: float) -> void:
	#This handles Coyote time
	if is_on_floor() or is_on_wall():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - delta, 0)
	jump_cooldown_timer = max(jump_cooldown_timer - delta, 0)
	
	move_and_slide()

#Jump logic
func can_jump() -> bool:
	##Return true if the player can jump, false otherwise.
	return (is_on_floor() or coyote_timer > 0) and jump_cooldown_timer <= 0

func perform_jump():
	##Have the player perform a jump.
	jump_cooldown_timer = jump_cooldown
	coyote_timer = 0
	velocity.y = -jump_impulse

#Movement logic
func perform_move(move_input: float):
	##Have the player move. Automatically factors in player speed.
	velocity.x = speed * move_input

#Wall logic
func can_wall_slide():
	return is_on_wall_only() and InputManager.is_move_pressed() and velocity.y > 0



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("water"):
		is_in_water = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("water"):
		is_in_water = false
