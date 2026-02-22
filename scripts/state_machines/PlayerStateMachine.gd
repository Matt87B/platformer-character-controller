class_name PlayerStateMachine extends StateMachine

@onready var movement_state_machine : StateMachine = $MovementStateMachine
@onready var status_state_machine : StateMachine = $StatusStateMachine

func _ready() -> void:
	_default = movement_state_machine
