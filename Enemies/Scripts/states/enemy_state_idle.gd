class_name EnemyStateIdle
extends EnemyState
@export_category("AI")
@export var anim_name : String = "idle"
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.0
@export var after_idle_state : EnemyStateWander  # Make sure this is set to your wander state in editor

var _timer : float = 0.0

func init()->void:
	pass


func Enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.update_animation(anim_name)

func Exit()-> void:
	pass
	
## process update in state
func Process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state
	return null

func Physics( _delta: float) -> EnemyState:
	return null
