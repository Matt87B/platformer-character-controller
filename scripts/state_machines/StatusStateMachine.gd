class_name StatusStateMachine extends StateMachine

@onready var normal_state : StateMachine = $NormalState
@onready var hurt_state : StateMachine = $DieState
@onready var die_state : StateMachine = $HurtState

const NORMAL = 9
const HURT = 10
const DIE = 11

func _ready() -> void:
	
	load_sub_state(normal_state)
	load_sub_state(hurt_state)
	load_sub_state(die_state)
	
	add_transition(normal_state, hurt_state, HURT)
	
	add_transition(hurt_state, die_state, DIE)
	add_transition(hurt_state, normal_state, NORMAL)
	
	add_transition(die_state, normal_state, NORMAL)
	
	_default = normal_state

func _on_update(_delta: float) -> void:
	pass
