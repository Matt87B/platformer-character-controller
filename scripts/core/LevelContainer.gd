extends Node

var _current_level: Node = null

func _ready() -> void:
	GameStateManager.level_load_requested.connect(_on_level_load_requested)
	GameStateManager.level_unload_requested.connect(_on_level_unload_requested)

## Called when the GSM requests a level to be loaded
func load_level(scene_path: String) -> void:
	_unload_current()
	var packed: PackedScene = load(scene_path)
	if packed == null:
		push_error("LevelContainer: failed to load level '%s'" % scene_path)
		return
	_current_level = packed.instantiate()
	add_child(_current_level)
	GameStateManager.level_loaded.emit()

func unload_level() -> void:
	_unload_current()

func _unload_current() -> void:
	if _current_level:
		_current_level.queue_free()
		_current_level = null

#Level load and unload hooks
func _on_level_load_requested(level_path: String) -> void:
	load_level(level_path)

func _on_level_unload_requested() -> void:
	# TODO: hook SaveManager here before unloading.
	unload_level()
