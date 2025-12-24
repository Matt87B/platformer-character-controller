class_name Player extends CharacterBody2D

@export var speed := 100.0
@export var swim_speed_dampening_factor := 0.25
@export var jump_impulse := 250.0
@export var coyote_time := 0.12
@export var jump_buffer_time := 0.12
var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var state_machine : StateMachine = $PlayerFSM
@onready var on_ground_state : StateMachine = $PlayerFSM/OnGroundState
@onready var fall_state : StateMachine = $PlayerFSM/OnGroundState/FallState
@onready var idle_state : StateMachine = $PlayerFSM/OnGroundState/IdleState
@onready var run_state : StateMachine = $PlayerFSM/OnGroundState/RunState
@onready var jump_state : StateMachine = $PlayerFSM/OnGroundState/JumpState

const FALL := 0
const IDLE := 1
const RUN := 2
const JUMP := 3

#adds and initializes each state and state machine
func _ready() -> void:
	on_ground_state.load_sub_state(idle_state)
	on_ground_state.load_sub_state(run_state)
	on_ground_state.load_sub_state(jump_state)
	on_ground_state.load_sub_state(fall_state)

	on_ground_state.add_transition(idle_state, run_state, RUN)
	on_ground_state.add_transition(idle_state, jump_state, JUMP)
	on_ground_state.add_transition(idle_state, fall_state, FALL)
	
	on_ground_state.add_transition(run_state, jump_state, JUMP)
	on_ground_state.add_transition(run_state, idle_state, IDLE)
	on_ground_state.add_transition(run_state, fall_state, FALL)
	
	on_ground_state.add_transition(jump_state, fall_state, FALL)
	
	on_ground_state.add_transition(fall_state, jump_state, JUMP)
	on_ground_state.add_transition(fall_state, run_state, RUN)
	
	on_ground_state.enter_state_machine(self)

func _physics_process(delta: float) -> void:
	#This handles Coyote time
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - delta, 0)
	#This creates a jump buffer timer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0)
	on_ground_state.update_state_machine(delta)
	
	move_and_slide()
