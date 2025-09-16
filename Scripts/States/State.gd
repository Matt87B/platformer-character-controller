#This node contains the methods that each state will inherit.
#Do not make any changes to this script.
class_name State extends Node

signal finished(next_state_path: String)

func _ready() -> void:
	pass 

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
	
func enter(previous_state_path: String) -> void:
	pass
	
func exit() -> void:
	pass
