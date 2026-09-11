extends Node

var target_scene_path: String = ""
var loading_screen_path: String = "res://scenes/user_interface/loading_screen.tscn"

func load_scene_path(path: String) -> void:
	target_scene_path = path
	ResourceLoader.load_threaded_request(target_scene_path)
	get_tree().change_scene_to_file(loading_screen_path)
