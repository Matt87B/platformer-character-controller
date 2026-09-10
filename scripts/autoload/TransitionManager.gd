extends CanvasLayer

var _color_rect: ColorRect
var _shader_material: Material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_color_rect = ColorRect.new()
	_color_rect.color = Color.BLACK
	_color_rect.visible = false
	
	_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_color_rect)


## Fades out to black (or covers the screen)
func fade_out(duration: float = 0.5) -> void:
	_color_rect.visible = true
	
	var _tween = create_tween()
	_tween.tween_property(_color_rect, "self_modulate:a", 1.0, duration).from(0.0)
	await _tween.finished

## Fades back in from black
func fade_in(duration: float = 0.5) -> void:
	_color_rect.visible = true
	
	var _tween = create_tween()
	_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_tween.tween_property(_color_rect, "self_modulate:a", 0.0, duration).from(1.0)
	await _tween.finished
	
	_color_rect.visible = false
	_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
