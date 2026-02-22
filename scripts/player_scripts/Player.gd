class_name Player extends CharacterBody2D

@export var speed := 100.0
@export var terminal_velocity := 200
@export var jump_impulse := 300.0
@export var min_jump_speed := 150.0
@export var coyote_time := 0.03
@export var jump_buffer_time := 0.05
@export var wall_slide_factor := 0.2
@export var wall_pushback := 250
@export var jump_cooldown := 0.2
@export var jump_cut_mult := 0.90

var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var jump_cooldown_timer := 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_in_water : bool = false

@onready var state_machine : StateMachine = $PlayerFSM

#Called when the player enters the scene tree
func _ready() -> void:
	state_machine.enter_state_machine(self)

func _physics_process(delta: float) -> void:
	#This handles Coyote time
	if is_on_floor() or is_on_wall():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - delta, 0)
	#This creates a jump buffer timer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0)
	
	jump_cooldown_timer = max(jump_cooldown_timer - delta, 0)
	
	state_machine.update_state_machine(delta)
	move_and_slide()

#Called whenever player enters or exits water
func _on_water_body_entered(_body: Node2D) -> void:
	is_in_water = true

func _on_water_body_exited(_body: Node2D) -> void:
	is_in_water = false
