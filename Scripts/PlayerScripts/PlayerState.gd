#This node is inherited by all player states.
class_name PlayerState extends State
#Player states for reference
const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const SWIMMING = "Swimming"
const FALLING = "Falling"

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await owner.ready
	player = owner as Player	#Casts player variable to Player class
	assert(player != null, "The PlayerState object cannot be instantiated; it must be used only from the player scene as a subclass of a Player object.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
