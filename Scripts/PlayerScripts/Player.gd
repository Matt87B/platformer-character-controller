class_name Player extends CharacterBody2D

@export var speed := 300.0
@export var swim_speed_dampening_factor := 0.25
@export var gravity := 4000.0
@export var jump_impulse := 1000.0

var in_water := false

func _physics_process(delta: float) -> void:
	
	move_and_slide()

func is_in_water() -> bool:
	return in_water
