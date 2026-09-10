extends Control

#signal navigate_to(scene_path)
signal go_back

func _on_back_pressed() -> void:
	go_back.emit()

func _on_select_output(device_name) -> void:
	AudioManager.set_output_device(device_name)

func _on_master_changed(value):
	AudioManager.set_master_volume(value)

func _on_sfx_changed(value) -> void:
	AudioManager.set_sfx_volume(value)

func _on_music_changed(value) -> void:
	AudioManager.set_music_volume(value)
