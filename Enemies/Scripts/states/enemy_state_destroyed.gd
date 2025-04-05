class_name EnemyStateDestroy
extends EnemyState

@export var knockback_speed: float = 150.0
@export var knockback_duration: float = 0.15  
@export var freeze_position_after: float = 0.5  

var _knockback_timer: float = 0.0
var _freeze_timer: float = 0.0
var _destroy_complete: bool = false
var _direction: Vector2
var _damage_position : Vector2

func Enter() -> void:
	enemy.Invurnerable = true
	_destroy_complete = false
	_knockback_timer = knockback_duration
	_freeze_timer = freeze_position_after

	# Get last attack details (fire, ice, etc.)
	var last_attack = enemy.last_hurt_box
	if last_attack != null:
		print("Destroyed by:", last_attack)

	# Knockback direction
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.velocity = -_direction * knockback_speed
	enemy.Set_Direction(_direction)

	# Play directional animation
	var destroy_anim = "destroy_" + enemy.anim_direction()
	if enemy.animation_player.has_animation(destroy_anim):
		enemy.animation_player.play(destroy_anim)
	else:
		enemy.animation_player.play("destroy")

	# Connect animation finished
	if enemy.animation_player.animation_finished.is_connected(_on_animation_finished):
		enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	disable_hurt_box()


func Process(delta: float) -> EnemyState:
	if _knockback_timer > 0:
		_knockback_timer -= delta
	else:
		enemy.velocity = Vector2.ZERO

	if _freeze_timer > 0:
		_freeze_timer -= delta

	return null
	pass  

func Physics(_delta: float) -> EnemyState:
	pass  
	return null

func _on_animation_finished(anim_name: String) -> void:
	if anim_name.begins_with("destroy") and not _destroy_complete and _freeze_timer <= 0:
		_destroy_complete = true
		enemy.queue_free()
	pass  

func disable_hurt_box() -> void:
	var hurt_box = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.set_deferred("monitoring", false)  # Disable collision detection
