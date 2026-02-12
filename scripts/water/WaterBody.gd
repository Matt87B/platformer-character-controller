extends Node2D

var points: Array[WaterPoint] = []
var bottom_points: Array = []
var water_width := 0

@export var tile_count := 13
@export var base_height := 0
@export var tension := 0.2
@export var non_linear_dampening := 0.015
@export var dampening := 0.95
@export var spread := 0.5
@export var iterations := 16
@export var impulse_factor := 0.05

@onready var area := $Area2D
@onready var collision_poly : CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var bottom_path := $Line2D

var water_poly : Polygon2D = Polygon2D.new()

func _ready() -> void:
	for j in range(tile_count * 8):
		var p = WaterPoint.new()
		p.rest_height = base_height
		p.height = base_height
		p.velocity = 0.0
		points.append(p)
	
	water_width = points.size()
<<<<<<< HEAD
	path_length = bottom_path.curve.get_baked_length()
	
	build_collision_from_path()

func build_collision_from_path():
	var poly = PackedVector2Array()
	poly.append(Vector2(0, base_height))
	poly.append(Vector2(points.size(), base_height))
	poly.append(Vector2(points.size(), 5 + base_height))
	poly.append(Vector2(0, 5 + base_height))

	polygon.polygon = poly
=======
	collision_poly.polygon = PackedVector2Array ([
		Vector2(0, base_height),
		Vector2(water_width, base_height),
		Vector2(water_width, base_height + 10),
		Vector2(0, base_height + 10)
		])
>>>>>>> 5dd1211f1082e038f5dc8fd54c7f03f865df9df6

func _draw():
	var heights := []

	water_poly.polygon = bottom_path.points

	for i in range(points.size()):
		var y = round(points[i].height)
		heights.append(y)
<<<<<<< HEAD
		poly.append(Vector2(i, y))
	
	for i in range(curve.get_point_count() - 1, -1, -1):
		var p = to_local(bottom_path.to_global(curve.get_point_position(i)))
		poly.append(p)
	draw_polygon(poly, [Color(0.2, 0.5, 1.0, 0.6)])
	
=======
		water_poly.polygon.append(Vector2(i, y))

	draw_polygon(water_poly.polygon, [Color(0.2, 0.5, 1.0, 0.6)])

>>>>>>> 5dd1211f1082e038f5dc8fd54c7f03f865df9df6
	for i in range(heights.size() - 1):
		draw_pixel_line(i, heights[i], i + 1, heights[i + 1])

func draw_pixel_line(x1, y1, x2, y2):
	var dx = x2 - x1
	var dy = y2 - y1
	var steps = max(1, max(abs(dx), abs(dy)))
	
	for s in range(steps + 1):
		var px = x1 + int(dx * s / steps)
		var py = y1 + int(dy * s / steps)
		draw_rect(Rect2(px, py, 1, 1), Color(0.2, 0.5, 1.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for p in points:
		var force = tension * (p.rest_height - p.height)
		p.velocity += force
		p.velocity *= dampening
		p.velocity *= 1.0 - abs(p.velocity) * non_linear_dampening
		p.height += p.velocity
		#var bottom_y = p.rest_height + 8
		#if p.height > bottom_y:
			#p.height = bottom_y
			#p.velocity = 0
	
	var iter_spread = spread/iterations
	for i in range(iterations):
		for j in range(points.size() - 1):
			var d = iter_spread * (points[j].height - points[j+1].height)
			points[j].velocity -= d
			points[j+1].velocity += d
		
		points[0].velocity *= 0.5
		points[points.size() - 1].velocity *= 0.5
	
	queue_redraw()

class WaterPoint:
	var height: float
	var velocity: float
	var rest_height: float

func splash(index: int, impulse: float):
	var v = impulse * impulse_factor
	points[index].velocity += v
	if index > 0: points[index - 1].velocity += impulse * impulse_factor * 0.5
	if index < points.size() - 1: points[index + 1].velocity += impulse * impulse_factor * 0.5

func _on_area_2d_body_entered(body: Node2D) -> void:
	var local_x = body.global_position.x - global_position.x
	var index = int(local_x)
	index = clamp(index, 0, points.size() - 1)
	
	splash(index, body.velocity.y)
