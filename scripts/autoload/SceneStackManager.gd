extends Node

var _container: Node
var _stack: Array[Node] = []

func initialize(container: Node) -> void:
	_container = container

##Stack helper functions
func push(scene_path: String) -> Node:
	if not _stack.is_empty() and _stack.back().scene_file_path == scene_path:
		return null
	if not ResourceLoader.exists(scene_path):
		push_error("Cannot open file '%s'." % scene_path)
		return null
	var scene: Node = load(scene_path).instantiate()
	_container.add_child(scene)
	_stack.append(scene)
	_update_visibility()
	return scene

func pop() -> void:
	if _stack.is_empty():
		return
	var scene: Node = _stack.pop_back()
	scene.queue_free()
	_update_visibility()

func replace(scene_path: String) -> Node:
	clear()
	return push(scene_path)

func clear() -> void:
	for scene in _stack:
		scene.queue_free()
	_stack.clear()

func peek() -> Node:
	return _stack.back() if not _stack.is_empty() else null

func is_empty() -> bool:
	return _stack.is_empty()

#Top scene is the only one visible
func _update_visibility() -> void:
	for i in _stack.size():
		var scene: Node = _stack[i]
		var is_top: bool = i == _stack.size() - 1
		scene.visible = is_top
		if is_top:
			if scene.has_method("on_stack_active"):
				scene.on_stack_active()
		else:
			if scene.has_method("on_stack_inactive"):
				scene.on_stack_inactive()
