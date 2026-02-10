extends Node2D

var points: Array[WaterPoint]

@export var width_px := 64
@export var spacing := 1
@export var base_height := 0
@export var water_depth := 10
@export var tension := 0.03
@export var non_linear_dampening := 0.015
@export var dampening := 0.92
@export var spread := 0.28
@export var iterations := 4
@export var impulse_factor := 0.04

@onready var area := $Area2D
@onready var polygon : CollisionPolygon2D = $Area2D/CollisionPolygon2D

func _ready() -> void:
	var count = int(width_px/spacing)
	for j in range(count):
		var p = WaterPoint.new()
		p.rest_height = base_height
		p.height = base_height
		p.velocity = 0.0
		points.append(p)
	init_collision_box()

func init_collision_box():
	var poly = CollisionPolygon2D.new()
	var vertices = PackedVector2Array([
		Vector2(0, 0),
		Vector2(width_px, 0),
		Vector2(width_px, water_depth),
		Vector2(0, water_depth)
	])
	poly.polygon = vertices
	polygon.polygon = vertices

func _draw():
	for i in range(points.size() - 1):
		var x1 = i * spacing
		var y1 = round(points[i].height)
		var x2 = (i + 1) * spacing
		var y2 = round(points[i + 1].height)
		
		var min_y = min(y1, y2)
		var max_y = max(y1, y2)
		for dx in range(x2 - x1 + 1):
			for dy in range(max_y - min_y + water_depth):
				draw_rect(Rect2(x1 + dx, min_y + dy, 1, 1), Color(0.2, 0.5, 1.0, 0.6))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	for p in points:
		var force = tension * (p.rest_height - p.height)
		p.velocity += force
		p.velocity *= dampening
		p.velocity *= 1.0 - abs(p.velocity) * non_linear_dampening
		p.height += p.velocity
	queue_redraw()
	
	var iter_spread = spread/iterations
	for i in range(iterations):
		for j in range(points.size() - 1):
			var discplacement = iter_spread * (points[j].height - points[j+1].height)
			points[j].velocity -= discplacement
			points[j+1].velocity += discplacement
		points[0].velocity *= -0.5
		points[points.size() - 1].velocity *= -0.5

class WaterPoint:
	var height: float
	var velocity: float
	var rest_height: float

func splash(index: int, impulse: float):
	points[index].velocity += impulse * impulse_factor

func _on_area_2d_body_entered(body: Node2D) -> void:
	var local_x = body.global_position.x - global_position.x
	var index = int(local_x / spacing)
	index = clamp(index, 0, points.size() - 1)
	
	splash(index, body.velocity.y)
