extends Node

var container: Control
var stack: Array = []

func initialize(ui_container: Control):
	container = ui_container

func push(scene_path: String):
	if not stack.is_empty():
		if stack.back().scene_file_path == scene_path:
			return
	var scene = load(scene_path).instantiate()
	container.add_child(scene)
	stack.append(scene)
	_update_stack()

func pop():
	if stack.is_empty():
		return

	var scene = stack.pop_back()
	scene.queue_free()
	_update_stack()

func replace(scene_path: String):
	while not stack.is_empty():
		pop()
	push(scene_path)
	_update_stack()

func peek():
	if stack.is_empty():
		return null
	return stack.back()

func _update_stack():
	for i in range(stack.size()):
		var scene = stack[i]
		var active = i == stack.size() - 1

		scene.visible = active
		scene.set_process(active)
		scene.set_process_input(active)
		scene.set_process_unhandled_input(active)
