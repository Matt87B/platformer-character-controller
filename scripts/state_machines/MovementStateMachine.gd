class_name MovementStateMachine extends StateMachine

@onready var on_ground_state : StateMachine = $OnGroundState
@onready var in_water_state : StateMachine = $InWaterState

const GROUND = 0
const SWIM = 1
const AIR = 2

func _ready() -> void:
	#Load general state transitions
	load_sub_state(on_ground_state)
	load_sub_state(in_water_state)
	
	add_transition(in_water_state, on_ground_state, GROUND)
	add_transition(on_ground_state, in_water_state, SWIM)
	
	_default = on_ground_state
	enter_state_machine(get_parent())

func _physics_process(delta: float) -> void:
	update_state_machine(delta)
