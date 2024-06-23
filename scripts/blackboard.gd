class_name BlackBoard extends Node2D


@export var basic_character_scene: PackedScene



# Called when the node enters the scene tree for the first time.
func _ready()->void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float)->void:
	pass

# EASING FUNCTIONS
func ease_in_circ(x: float) -> float:
	return 1 - sqrt(1 - pow(x, 2));

func ease_in_quad(x: float) -> float:
	return x*x

func ease_in_quart(x: float) -> float:
	return pow(x, 4)
#-----------

func get_distance_from_closest_edge_score(target_position: Vector2)->float:
	#----------- get the edges rect
	var viewport_rect: Rect2 = get_viewport_rect()
	#----------- get the rect center
	var viewport_center:Vector2 = viewport_rect.get_center()
	#----------- get the closest point to the position on the closest edge:
	#-----------	check the point poisition against:
	#-----------	top edge: Vector2(point.x, rect_center + rect_size.y/2)
	#-----------	right edge: Vector2(rect_center + rect_size.x/2, point.y)
	#-----------	bottom edge: Vector2(point.x, rect_center - rect_size.y/2)
	#-----------	left edge: Vector2(rect_center - rect_size.x/2, point.y)
	var viewport_size: Vector2 = viewport_rect.size
	var top_edge:Vector2 = Vector2(target_position.x, viewport_center.y + viewport_size.y/2)
	var right_edge:Vector2 = Vector2(viewport_center.x + viewport_size.x/2, target_position.y)
	var bottom_edge:Vector2 = Vector2(target_position.x,viewport_center.y - viewport_size.y/2)
	var left_edge:Vector2 = Vector2(viewport_center.x - viewport_size.x/2, target_position.y)
	var edges: Array[Vector2] = [
		top_edge,
		right_edge,
		bottom_edge,
		left_edge,
		]

	#----------- get the closest edge
	var closest_edge_point: Vector2 = Vector2.INF
	for edge : Vector2 in edges:
		if edge.distance_to(target_position) < target_position.distance_to(closest_edge_point):
			closest_edge_point = edge

	
	#----------- get the distance between the closest point on edge and the point
	var distance_from_edge:float = target_position.distance_to(closest_edge_point)
	#----------- transform the distance into a normalized value (0-1):
	#-----------	get distance_t_center_edge: segment between the rect_center translated to be perpendicular to the edge and the edge closest point
	var max_distance_from_edge: float = 0.0
	if closest_edge_point.x == target_position.x: # vertical edge
		max_distance_from_edge = viewport_size.y/2
	else:
		max_distance_from_edge = viewport_size.x/2
	
	var normalized_distance: float = 1.0 - (distance_from_edge / max_distance_from_edge)

	return ease_in_quart(normalized_distance)

	#-----------		example: point is closest to the right edge: rect_center becomes Vector2(center.x, point.y)
	#-----------	normalized_distance_from_closest_edge = distance_point_edge / distance_t_center_edge


func get_all_children(in_node: Node, array := [])-> Array[Node]:
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array

func get_closest_character(target_character: BasicCharacter) -> BasicCharacter:
	#-----------	get all characters
	var characters:Array[BasicCharacter] = []
	var scene_nodes: Array[Node] = get_all_children(get_tree().get_root())
	for node in scene_nodes:
		if node is BasicCharacter and node != target_character:
			characters.push_back(node)
	#-----------	get closest character
	var closest_character: BasicCharacter 
	for character in characters:
		if character.global_position.distance_to(target_character.global_position) < target_character.global_position.distance_to(
			Vector2.INF if closest_character == null else closest_character.global_position
			):
			closest_character = character
	return closest_character



func get_closest_character_distance_score(target_character:BasicCharacter) -> float:
	var closest_character: BasicCharacter = get_closest_character(target_character)
	if closest_character == null:
		return 0.0
	var distance: float = target_character.global_position.distance_to(closest_character.global_position)

	#----------- max distance = viewport diagonal
	var max_distance: float = sqrt(pow(get_viewport_rect().size.x,2) + pow(get_viewport_rect().size.y,2))
	return ease_in_quart(1.0 - distance / max_distance)





var count: int = 1

func _on_timer_timeout() -> void:
	var new_character: BasicCharacter = basic_character_scene.instantiate()
	new_character.blackBoard = self
	new_character.position = Vector2.ZERO
	self.add_child(new_character)
	new_character.global_position =  get_viewport_rect().get_center()
	count+=1
	print(count)
	# getting all action scores in physics_process tanks the fps at about 40 characters (on windows destkop)


