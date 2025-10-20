class_name StateMachine extends Node2D

##The current state of the player
var _current: StateMachine
##The starting state of the player
@export var _default: StateMachine
##The parent state machine
var _parent: StateMachine
##This dictionary contains information about the substates of this state machine
var _sub_states: Dictionary = {}
##This dictionary holds information for states and their respective state transitions
var _transitions: Dictionary = {}
##Reference to the player node
var player : Player

##This function enters the current state
func enter_state_machine(p: Player) -> void:
	self.player = p
	_on_enter()
	if (_current == null and _default != null):
		_current = _default
	if (_current != null):
		_current.enter_state_machine(player)

##This function updates the current state
func update_state_machine(delta: float) -> void:
	if _current != null:
		_current.update_state_machine(delta)
	_on_update(delta)

##This function exits the current state
func exit_state_machine() -> void:
	if _current != null:
		_current.exit_state_machine()
	_on_exit()
##This function is called when this state machine is entered.
##Override it and add the necessary code your state.
func _on_enter() -> void: pass

##This function is called when this state machine is exited.
##Override it and add the necessary code your state.
func _on_exit() -> void: pass

##This function is called when this state machine is updated.
##Override it and add the necessary code your state.
func _on_update(_delta: float) -> void: pass

func load_sub_state(sub_state: StateMachine) -> void:
	if (_sub_states.is_empty()):
		_default = sub_state
	
	sub_state._parent = self
	
	if _sub_states.has(sub_state.get_state_type()):
		push_error("State %s already contains a substate of type %s" % [get_state_type(), sub_state.get_state_type()])
		return
	
	_sub_states[sub_state.get_state_type()] = sub_state
##Returns the class_name of this state machine
func get_state_type() -> String:
	return get_script().get_global_name()
##Adds a transition 
func add_transition(from: StateMachine, to: StateMachine, trigger: int) -> void:
	if not _sub_states.has(from.get_state_type()):
		push_error("State %s does not have a substate of type %s to transition from." %[get_state_type(), from.get_state_type()])
		return
	
	if not _sub_states.has(to.get_state_type()):
		push_error("State %s does not have a substate of type %s to transition from." % [get_state_type(), to.get_state_type()])
		return
	
	if from._transitions.has(trigger):
		push_error("State %s already has a transition defined for trigger %s" % [str(from), str(trigger)])
		return
	
	from._transitions[trigger] = to
##Sends a trigger up the node tree, telling parent nodes to change the state
func send_trigger(trigger: int) -> void:
	var root : StateMachine = self
	
	while root != null and root._parent != null:
		root = root._parent
	
	while root != null:
		if root._transitions.has(trigger):
			var to_state: StateMachine = root._transitions[trigger]
			if root._parent != null:
				root._parent._change_sub_state(to_state)
			return
		
		root = root._current
	
	push_error("Trigger %s was not consumed by any transition." % str(trigger))
##Changes substate to a new state
func _change_sub_state(state: StateMachine):
	if _current != null:
		_current.exit_state_machine()
		var new_state : StateMachine = _sub_states[state.get_state_type()]
		_current = new_state
		new_state.enter_state_machine(player)
		return
	
	push_error("Cannot change sub state from null state.")
