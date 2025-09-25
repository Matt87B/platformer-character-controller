class_name StateMachine extends Node2D

var _current: StateMachine
var _default: StateMachine
var _parent: StateMachine

var _sub_states: Dictionary
var _transitions: Dictionary

func enter_state_machine() -> void:
	_on_enter()
	if (_current == null):
		_current = _default
	_current.enter_state_machine()

func update_state_machine(delta: float) -> void:
	_on_update(delta)
	_on_exit()

func exit_state_machine() -> void:
	_current.exit_state_machine()
	_on_exit()

func _on_enter() -> void: pass

func _on_exit() -> void: pass

func _on_update(delta: float) -> void: pass

func load_sub_state(sub_state: StateMachine) -> void:
	if (_sub_states.is_empty()):
		_default = sub_state
	
	_parent = self
	
	if _sub_states.has(sub_state.get_class()):
		push_error("State %s already contains a substate of type %s" % [get_class(), sub_state.get_class()])
		return
	
	_sub_states[sub_state.get_class()] = sub_state

func add_transition(from: StateMachine, to: StateMachine, trigger: int) -> void:
	if not _sub_states.has(from.get_class()):
		push_error("State %s does not have a substate of type %s to transition from." %[self, from.get_class()])
		return
	
	if not _sub_states.has(to.get_class()):
		push_error("State %s does not have a substate of type %s to transition from." % [get_class(), to.get_class()])
		return
	
	if from._transitions.has(trigger):
		push_error("State %s already has a transition defined for trigger %s" % [str(from), str(trigger)])
		return
	
	from._transitions[trigger] = to

func send_trigger(trigger: int) -> void:
	var root : StateMachine = self
	
	while root != null and root.parent != null:
		root = root._parent
	
	while root != null:
		if root._transitions.has(trigger):
			var to_state: StateMachine = root._transitions[trigger]
			if root._parent != null:
				root.parent.change_sub_state(to_state)
			return
		
		root = root._current
	
	push_error("Trigger %s was not consumed by any transition." % str(trigger))

func change_sub_state(state: StateMachine):
	if _current != null:
		_current.exit_state_machine()
		var new_state : StateMachine = _sub_states[state.get_class()]
		_current = new_state
		new_state.enter_state_machine()
		return
	
	push_error("Cannot change sub state from null state.")
