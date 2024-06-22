extends CharacterBody2D


const SPEED = 300.0

var lastDirection = Vector2.RIGHT

@export var blackBoard:BlackBoard


var actions = [
	{
	'action_fn': idle,
	'value_fn': get_idle_score
	},
	{
	'action_fn': move_away_from_edge,
	'value_fn': get_move_away_from_edge_score
	},
]

func get_idle_score():
	return RandomNumberGenerator.new().randf_range(0.5,0.9)

func get_move_away_from_edge_score():
	return blackBoard.get_distance_from_closest_edge(global_position)
func sort_descending(a, b):
	if a.value > b.value:
		return true
	return false
func compute_action_value(action):
	action.value = action.value_fn.call()
	return action


func _physics_process(_delta):
	move_and_slide()

func _on_desicion_timer_timeout():
	var resolved_actions = actions.map(compute_action_value)
	resolved_actions.sort_custom(sort_descending)

	resolved_actions[0].action_fn.call()





func idle():
	var direction = Vector2(1,1)
	direction.x = (randf() - 0.5)
	direction.y = (randf() - 0.5)

	direction = (lastDirection + direction).normalized()
	lastDirection = direction
	if direction:
		velocity = direction * SPEED

func move_away_from_edge():
	var viewport_rect: Rect2 = get_viewport_rect()
	#----------- get the rect center
	var viewport_center = viewport_rect.get_center()

	var direction = (global_position.direction_to(viewport_center) + lastDirection).normalized()
	lastDirection = direction

	velocity = direction * SPEED




