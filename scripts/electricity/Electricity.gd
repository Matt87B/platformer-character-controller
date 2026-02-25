extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func draw_pixel_line(x1, y1, x2, y2):
	var dx = x2 - x1
	var dy = y2 - y1
	var steps = max(1, max(abs(dx), abs(dy)))
	
	for s in range(steps + 1):
		var px = x1 + int(dx * s / steps)
		var py = y1 + int(dy * s / steps)
		draw_rect(Rect2(px, py, 1, 1), Color(0.2, 0.5, 1.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
