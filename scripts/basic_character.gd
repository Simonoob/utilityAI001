class_name BasicCharacter extends CharacterBody2D


const SPEED = 300.0

var lastDirection: Vector2 = Vector2.RIGHT
signal position_updated(new_position:Vector2)

@export var blackBoard:BlackBoard


var actions: Array[Dictionary] = [
	{
	'action_fn': idle,
	'value_fn': get_idle_score
	},
	{
	'action_fn': move_away_from_edge,
	'value_fn': get_move_away_from_edge_score
	},
	{
	'action_fn': move_away_from_closest_character,
	'value_fn': get_move_away_from_closest_character_score
	},
]

func get_idle_score()->float:
	return RandomNumberGenerator.new().randf_range(0.5,0.9)

func get_move_away_from_edge_score()->float:
	return blackBoard.get_distance_from_closest_edge_score(global_position)

func get_move_away_from_closest_character_score()->float:
	return blackBoard.get_closest_character_distance_score(self)



func sort_descending(a:Dictionary, b:Dictionary)->bool:
	if a.value > b.value:
		return true
	return false
func compute_action_value(action:Dictionary)->Dictionary:
	action.value = action.value_fn.call()
	return action


func _physics_process(_delta:float)->void:
	var resolved_actions:Array = actions.map(compute_action_value)
	resolved_actions.sort_custom(sort_descending)

	resolved_actions[0].action_fn.call()
	move_and_slide()
	position_updated.emit(global_position)





func idle()->void:
	var direction: Vector2 = Vector2(1,1)
	direction.x = (randf() - 0.5)
	direction.y = (randf() - 0.5)

	direction = (lastDirection + direction).normalized()
	lastDirection = direction
	if direction:
		velocity = direction * SPEED

func move_away_from_edge()->void:
	var viewport_rect: Rect2 = get_viewport_rect()
	#----------- get the rect center
	var viewport_center:Vector2 = viewport_rect.get_center()

	var direction:Vector2 = (global_position.direction_to(viewport_center) + lastDirection).normalized()
	lastDirection = direction

	velocity = direction * SPEED

func move_away_from_closest_character()->void:
	var closest_character:BasicCharacter = blackBoard.get_closest_character(self)
	var direction:Vector2 = (-global_position.direction_to(closest_character.global_position) + lastDirection).normalized()
	lastDirection = direction

	velocity = direction * SPEED



