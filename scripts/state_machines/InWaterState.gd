class_name InWaterState extends StateMachine

@onready var swim_state : StateMachine = $SwimState

const SWIM = 8

func _ready() -> void:
	#Create more swim states (sink, dash, etc.)
	load_sub_state(swim_state)

func _on_update(_delta: float) -> void:
	if not player.is_in_water:
		send_trigger(MovementStateMachine.GROUND)
