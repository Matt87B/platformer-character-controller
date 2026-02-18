class_name PlayerStateMachine extends StateMachine

@onready var movement_state_machine : StateMachine = $MovementStateMachine

func _ready() -> void:
	_default = movement_state_machine
