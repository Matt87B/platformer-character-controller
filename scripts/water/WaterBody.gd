extends Node2D

var points: Array[WaterPoint] = []
var bodies_in_water : Array= []
var water_width := 0

@export var tile_count := 13
@export var base_height := 1
@export var tension := 3
@export var non_linear_dampening := 0.015
@export var dampening := 0.93
@export var spread := 0.5
@export var iterations := 8
@export var impulse_factor := 0.3

@export var test_body_half_width := 2.0
@export var depth_decay := 0.08
@export var buoyancy_strength := 0.04
@export var drag_strength := 0.02

@onready var collision_poly : CollisionPolygon2D = $Area2D/CollisionPolygon2D
@onready var bottom_path := $Line2D

func _ready() -> void:
	for j in range(tile_count * 8):
		var p = WaterPoint.new()
		p.rest_height = base_height
		p.height = base_height
		p.velocity = 0.0
		points.append(p)
	
	water_width = points.size()
	
	#Initialize the collision polygon
	collision_poly.polygon = PackedVector2Array ([
		Vector2(0, base_height),
		Vector2(water_width, base_height),
		Vector2(water_width, base_height + 32),
		Vector2(0, base_height + 32)
		])

#Draws the water's surface and body
func _draw():
	var heights := []
	var bottom_points = bottom_path.points
	var water_poly := PackedVector2Array()
	
	#Append Line2D points to the polygon from right to left
	for i in range(bottom_points.size() - 1, -1, -1):
		water_poly.append(bottom_points[i])
	
	#Append water surface points to the polygon from left to right
	for i in range(points.size()):
		#Store heights value into heights array for future reference
		heights.append(round(points[i].height))
		var y = heights[i]
		water_poly.append(Vector2(i, y))
		
	
	#Add last point at the end of the water surface line to complete the polygon
	water_poly.append(Vector2(water_width, base_height))
	
	#Draw water fill polygon
	draw_polygon(water_poly, [Color(0.2, 0.5, 1.0, 0.6)])
	
	#Draw the water's surface
	for i in range(heights.size() - 1):
		draw_pixel_line(i, heights[i], i + 1, heights[i + 1])

func get_bottom_y_at_x(x: float) -> float:
	var pts = bottom_path.points

	for i in range(pts.size() - 1):
		var p1 = pts[i]
		var p2 = pts[i + 1]
		if x >= p1.x and x <= p2.x:
			var t = (x - p1.x) / (p2.x - p1.x)
			return lerp(p1.y, p2.y, t)
	#If x is outside the line
	if x < pts[0].x:
		return pts[0].y
	return pts[-1].y

#Draw the water surface line as pixels
func draw_pixel_line(x1, y1, x2, y2):
	var dx = x2 - x1
	var dy = y2 - y1
	var steps = max(1, max(abs(dx), abs(dy)))
	
	for s in range(steps + 1):
		var px = x1 + int(dx * s / steps)
		var py = y1 + int(dy * s / steps)
		draw_rect(Rect2(px, py, 1, 1), Color(0.2, 0.5, 1.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for p in points:
		var force = tension * (p.rest_height - p.height)
		p.velocity += force * delta
		p.velocity *= dampening
		p.height += p.velocity

	var iter_spread = spread / iterations
	for i in range(iterations):
		for j in range(points.size() - 1):
			var diff = points[j].height - points[j+1].height
			var d = iter_spread * diff
			points[j].velocity -= d
			points[j+1].velocity += d
		points[0].velocity *= 0.5
		points[points.size() - 1].velocity *= 0.5
	apply_body_forces(delta)
	queue_redraw()

class WaterPoint:
	var height: float
	var velocity: float
	var rest_height: float

func splash(x: int, impulse: float):
	points[x].velocity += impulse
	if x > 0:
		points[x-1].velocity += impulse * 0.5
	if x < points.size()-1:
		points[x+1].velocity += impulse * 0.5

func apply_body_forces(delta):
	for body in bodies_in_water:
		var local_pos = to_local(body.global_position)
		var x = int(local_pos.x)
		x = clamp(x, 0, points.size()-1)
		
		var surface_y = points[x].rest_height
		var bottom_y = get_bottom_y_at_x(x)
		var water_depth = bottom_y - surface_y
		
		if water_depth <= 0:
			continue
		
		var body_depth = local_pos.y - surface_y
		var influence = 1.0 - clamp(body_depth / (water_depth + 8), 0.0, 1.0)
		var impulse = body.velocity.y * 0.5
		impulse += abs(body.velocity.x) * impulse_factor
		splash(x, impulse * influence * delta)

func _on_area_2d_body_entered(body: Node2D) -> void:
	bodies_in_water.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	bodies_in_water.erase(body)
