class_name EnemyStateStun
extends EnemyState

@export var anim_name: String = "stun"
@export var kockback_speed: float = 150.0
@export var decelerate_speed: float = 10.0
@export var next_state: EnemyState  

var _damage_position : Vector2
var _animation_finished: bool = false
var _direction: Vector2

func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	pass  

func Enter() -> void:
	enemy.Invurnerable = true
	_animation_finished = false
	_direction = enemy.global_position.direction_to(_damage_position)
	 
	enemy.velocity = _direction * -kockback_speed
	enemy.Set_Direction(_direction)
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	pass  

func Exit() -> void:
	enemy.Invurnerable = false
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass  

func Process(_delta: float) -> EnemyState:
	if _animation_finished:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func Physics(_delta: float) -> EnemyState:
	pass  
	return null

func _on_enemy_damaged(hurt_box: HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)
	pass  

func _on_animation_finished(_a: String) -> void:
	_animation_finished = true
	pass  
