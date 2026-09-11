extends Node

var target_scene_path: String = ""
var loading_screen_path: String = "res://scenes/ui/loading_screen.tscn"

func load_scene_path(path: String) -> void:
	target_scene_path = path
	ResourceLoader.load_threaded_request(target_scene_path)
	get_tree().change_scene_to_file(loading_screen_path)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
