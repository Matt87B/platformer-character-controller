extends Node

var current_level: Node = null
var current_path := ""

func load_level(path: String):
	if path == current_path:
		return
	
	var level_scene = load(path).instantiate()
	if current_level:
		current_level.queue_free()
	add_child(level_scene)
	current_level = level_scene
	current_path = path
	
func unload_level():
	if current_level:
		current_level.queue_free()
		current_level = null
		current_path = ""

func reload_level():
	if current_path != "":
		load_level(current_path)

func has_level() -> bool:
	return current_level != null
