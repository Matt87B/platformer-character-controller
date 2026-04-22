extends Camera2D

enum CameraMode {
	FOLLOW,
	CINEMATIC
}

var mode: CameraMode = CameraMode.FOLLOW
var target: Node2D = null
var _tween: Tween = null

@export var follow_smoothing := 5.0
@export var look_ahead_distance := 20.0
@export var bounds: Rect2

func _physics_process(delta: float) -> void:
	if mode == CameraMode.FOLLOW and target:
		_follow(delta)

func _follow(delta: float) -> void:
	var desired_pos := target.global_position
	
	if target is Player:
		desired_pos.x += target.get_facing() * look_ahead_distance
	
	if bounds != Rect2():
		desired_pos = desired_pos.clamp(bounds.position, bounds.end)
	global_position = global_position.lerp(desired_pos, follow_smoothing * delta)

func cinematic_move_to(dest: Vector2, duration: float, return_to_follow: bool = true) -> void:
	mode = CameraMode.CINEMATIC
	if _tween:
		_tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(self, "global_position", dest, duration)
	if return_to_follow:
		_tween.tween_callback(func(): mode = CameraMode.FOLLOW)

func set_bounds(new_bounds: Rect2):
	bounds = new_bounds

func clear_bounds() -> void:
	bounds = Rect2()
