class_name StateMachine extends State

@export var initial_state : State = null
var states: Dictionary = {}
var transition_map: Dictionary = {
	"Idle": {
		"move" : "Running",
		"jump" : "Jumping"
	},
	"Running": {
		"stop" : "Idle",
		"jump" : "Jumping",
		"fall" : "Falling"
	},
	"Falling": {
		"stop" : "Idle",
		"move" : "Running"
	},
	"Jumping": {
		"stop" : "Idle",
		"fall" : "Falling",
		"run" : "Running"
	}
}

#Check if initial_state has been selected, otherwise default to first child of this node
@onready var current_state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

func _ready() -> void:
	for child in get_children():
		if child is State:
			transition_map[child.name] = child

func handle_input(event: InputEvent) -> void:
	#Handles user input
	if current_state:
		current_state.handle_input(event)

func update(delta: float) -> void:
	#Update non-physics related (Animations, etc.)
	if current_state:
		current_state.update(delta)

func physics_update(delta: float) -> void:
	#Update physics related things (Movement, gravity, etc.)
	if current_state:
		current_state.physics_update(delta)

func set_state(new_state: State):
	if current_state:
		current_state.exit()
		current_state.transition_requested.disconnect(_on_event)
	current_state = new_state
	if current_state:
		current_state.transition_requested.connect(_on_event)
	
	if current_state is StateMachine:
		if current_state.initial_state:
			current_state.set_state(current_state.get_node(current_state.initial_state))
		
func _on_event(event: String):
	var state_name = current_state.name
	if state_name in transition_map:
		if event in transition_map[state_name]:
			#Change state to next state according to dictionary of states and events
			set_state(get_node(transition_map[state_name][event]))
		else:
			#Bubble up signal to change states
			if owner is StateMachine:
				owner._on_event(event)
