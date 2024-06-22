class_name BlackBoard extends Node2D






# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_distance_from_closest_edge(target_position: Vector2):
	#----------- get the edges rect
	var viewport_rect: Rect2 = get_viewport_rect()
	#----------- get the rect center
	var viewport_center = viewport_rect.get_center()
	#----------- get the closest point to the position on the closest edge:
	#-----------	check the point poisition against:
	#-----------	top edge: Vector2(point.x, rect_center + rect_size.y/2)
	#-----------	right edge: Vector2(rect_center + rect_size.x/2, point.y)
	#-----------	bottom edge: Vector2(point.x, rect_center - rect_size.y/2)
	#-----------	left edge: Vector2(rect_center - rect_size.x/2, point.y)
	var viewport_size: Vector2 = viewport_rect.size
	var top_edge = Vector2(target_position.x, viewport_center.y + viewport_size.y/2)
	var right_edge = Vector2(viewport_center.x + viewport_size.x/2, target_position.y)
	var bottom_edge = Vector2(target_position.x,viewport_center.y - viewport_size.y/2)
	var left_edge = Vector2(viewport_center.x - viewport_size.x/2, target_position.y)
	var edges = [
		top_edge,
		right_edge,
		bottom_edge,
		left_edge,
		]

	#----------- get the closest edge
	var closest_edge_point: Vector2 = Vector2.ZERO
	for edge : Vector2 in edges:
		if edge.distance_to(target_position) < target_position.distance_to(closest_edge_point):
			closest_edge_point = edge

	
	#----------- get the distance between the closest point on edge and the point
	var distance_from_edge = target_position.distance_to(closest_edge_point)
	#----------- transform the distance into a normalized value (0-1):
	#-----------	get distance_t_center_edge: segment between the rect_center translated to be perpendicular to the edge and the edge closest point
	var max_distance_from_edge: float = 0.0
	if closest_edge_point.x == target_position.x: # vertical edge
		max_distance_from_edge = viewport_size.y/2
	else:
		max_distance_from_edge = viewport_size.x/2
	
	var normalized_distance: float = 1.0 - (distance_from_edge / max_distance_from_edge)

	return normalized_distance

	#-----------		example: point is closest to the right edge: rect_center becomes Vector2(center.x, point.y)
	#-----------	normalized_distance_from_closest_edge = distance_point_edge / distance_t_center_edge




