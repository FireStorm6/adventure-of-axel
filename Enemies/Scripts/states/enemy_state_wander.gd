class_name EnemyStateWander
extends EnemyState

@export_category("AI")
@export var anim_name : String = "walk"
@export var wander_speed : float = 30.0
@export var state_animation_duration: float = 0.5
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 5
@export var next_state : EnemyState  # Make sure this is assigned in editor!

var _timer : float = 0.0
var _direction : Vector2

func init() -> void:
	# Empty but preserved as you requested
	pass

func Enter() -> void:
	# Initialize wander behavior
	_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
	var rand = randi_range(0, 3)
	_direction = enemy.DIR_4[rand]  # Ensure enemy has DIR_4 constant
	enemy.velocity = _direction * wander_speed
	enemy.Set_Direction(_direction)
	enemy.update_animation(anim_name)
	
	# Debug print (remove after testing)
	print("Entering Wander State | Direction: ", _direction, " | Duration: ", _timer)

func Exit() -> void:
	# Empty but preserved
	pass

func Process(_delta: float) -> EnemyState:
	_timer -= _delta
	
	# Continue applying movement (added this critical line)
	enemy.velocity = _direction * wander_speed
	
	if _timer <= 0:
		# Debug print (remove after testing)
		print("Wander complete, transitioning to: ", 
			  next_state.name if next_state else "null")
		return next_state
	return null

func Physics(_delta: float) -> EnemyState:
	# Empty but preserved
	return null
