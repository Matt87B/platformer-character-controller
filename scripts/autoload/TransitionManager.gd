class_name TransitionManager

extends Control

enum Type {
	FADE_TO_BLACK,
	FADE_FROM_BLACK,
	CIRCLE_TO_BLACK,
	CIRCLE_FROM_BLACK
}

@onready var _color_rect: ColorRect = $ColorRect

const SHADERS = {
	"pixel_iris": preload("res://assets/shaders/pixel_iris.gdshader"),
	"fade": preload("res://assets/shaders/fade.gdshader")
}

@export var fade_duration: float = 1.5
@export var circle_duration: float = 1

func _ready() -> void:
	GameStateManager.state_changed.connect(_on_state_changed)
	GameStateManager.transition_requested.connect(_on_transition_requested)

##Reacts to state changes from the GSM
func _on_state_changed(state: GameStateManager.GameState) -> void:
	## TODO: Revise whether this hook is necessary
	match state:
		GameStateManager.GameState.TRANSITION:
			pass

func _on_transition_requested(type: Type) -> void:
	match type:
		Type.FADE_TO_BLACK:
			_transition_to_black("fade", fade_duration)
		Type.FADE_FROM_BLACK:
			_transition_from_black("fade", fade_duration)
		Type.CIRCLE_TO_BLACK:
			_transition_to_black("pixel_iris", circle_duration)
		Type.CIRCLE_FROM_BLACK:
			_transition_from_black("pixel_iris", circle_duration)

func _transition_to_black(type: String, duration: float = 0.5, player: Node2D = null) -> Signal:
	get_tree().paused = true
	_color_rect.visible = true
	
	var shader_res = SHADERS.get(type, SHADERS.get("fade"))
	if shader_res == null:
		push_error("Shader resource for type '%s' could not be found or loaded!" % type)
		return create_tween().finished

	var mat = ShaderMaterial.new()
	mat.shader = shader_res
	_color_rect.material = mat

	if type == "pixel_iris" and player != null:
		var screen_pos = player.get_global_transform_with_canvas().origin
		var viewport_size = get_viewport().get_visible_rect().size
		mat.set_shader_parameter("player_screen_position", screen_pos / viewport_size)

	var tween = create_tween()
	tween.tween_method(
		func(val: float): mat.set_shader_parameter("progress", val),
		0.0, # Start value
		1.0, # End value
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	return tween.finished

func _transition_from_black(type: String, duration: float = 0.5, player: Node2D = null) -> Signal:
	get_tree().paused = true
	_color_rect.visible = true
	
	var shader_res = SHADERS.get(type, SHADERS.get("fade"))
	if shader_res == null:
		push_error("Shader resource for type '%s' could not be found or loaded!" % type)
		_color_rect.visible = false
		get_tree().paused = false
		return create_tween().finished

	var mat = ShaderMaterial.new()
	mat.shader = shader_res
	_color_rect.material = mat

	if type == "pixel_iris" and player != null:
		var screen_pos = player.get_global_transform_with_canvas().origin
		var viewport_size = get_viewport().get_visible_rect().size
		mat.set_shader_parameter("player_screen_position", screen_pos / viewport_size)

	var tween = create_tween()
	var early_unpaused := false
	
	const EARLY_FINISH_THRESHOLD := 0.2

	tween.tween_method(
		func(val: float):
			mat.set_shader_parameter("progress", val)
			
			if not early_unpaused and val <= EARLY_FINISH_THRESHOLD:
				early_unpaused = true
				get_tree().paused = false,
		1.0, # Start
		0.0, # End
		duration
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	var signal_finished = tween.finished
	signal_finished.connect(func():
		_color_rect.visible = false
		if get_tree().paused:
			get_tree().paused = false
	, CONNECT_ONE_SHOT)
	
	return signal_finished
