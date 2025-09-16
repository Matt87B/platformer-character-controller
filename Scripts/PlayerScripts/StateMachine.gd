#This node can be the child of the Player node, or another StateMachine node.
#It's children must be of type State or StateMachine. 
class_name StateMachine extends State

@export var initial_node = null

#Check if initial_node has been selected, otherwise default to first child of this node
@onready var current: Node = (
	func get_initial() -> Node:
		if initial_node:
			return initial_node
		for child in get_children():
			if child is State or child is StateMachine:
				return child
		push_error("Could not find a child node of type State or StateMachine when looking for what to set the current state")
		return null
).call()

#Iterates through all children, checking if they are State nodes.
#Each state is connected to the _transition_to_next_state function.
#This allows current states to signal when to exit and switch to another state at the next_state_path.
func _ready() -> void:
	for child in get_children():
		if child is State:
			child.finished.connect(_transition_to_next_state)
		else:
			push_error("The node ", child.get_path(), " must be of type State or StateMachine.")
		
	await owner.ready
	current.enter("")

#Handle user input
func handle_input(event: InputEvent) -> void:
	current.handle_input(event)

#Update non-physics related (Animations, etc.)
func update(delta: float) -> void:
	current.update(delta)

#Update physics related things (Movement, gravity, etc.)
func physics_update(delta: float) -> void:
	current.physics_update(delta)

#Transitions to the next state, given a target_path. Passes this to the parent of this node if no state is found.
func _transition_to_next_state(target_path: String) -> void:
	#If state does not exist, send finished signal up the hierarchy
	if not has_node(target_path):
		if get_parent() == null:
			printerr(owner.name + ": Transition to non existant state at" + target_path)
			return
		finished.emit(target_path)
		return
	#If state does exist, set previous state path and exit the current state. Switch to next state specified by target_state_path
	var previous_path := current.name
	current.exit()
	current = get_node(target_path)
	current.enter(previous_path)
