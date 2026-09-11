extends Control

@export var progress_bar: ProgressBar

var progress_array: Array = []
var load_status: ResourceLoader.ThreadLoadStatus

func _ready() -> void:
	# Ensure progress bar matches 0-100 range if desired
	if progress_bar:
		progress_bar.max_value = 100.0
		progress_bar.value = 0.0

func _process(_delta: float) -> void:
	# Fetch current loading status and progress ratio (0.0 to 1.0)
	load_status = ResourceLoader.load_threaded_get_status(
		SceneLoader.target_scene_path, 
		progress_array
	)
	
	match load_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if progress_array.size() > 0:
				var percent = progress_array[0] * 100.0
				if progress_bar:
					progress_bar.value = percent
					
		ResourceLoader.THREAD_LOAD_LOADED:
			# Fully loaded! Set progress to 100 and fetch the resource
			if progress_bar:
				progress_bar.value = 100.0
				
			var packed_scene = ResourceLoader.load_threaded_get(SceneLoader.target_scene_path)
			get_tree().change_scene_to_packed(packed_scene)
			
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error: Failed to load target scene.")
			# Handle error / fallback transition here
			set_process(false)
			
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print("Error: Invalid resource path.")
			set_process(false)
