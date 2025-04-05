class_name State_Stun extends State

@export var knockback_speed : float = 30.0
@export var deacelerate_speed : float = 10.0
@export var invurnerable_duration : float = 1.0
@onready var idle: State = $"../Idle"

var hurt_box : HurtBox
var direction : Vector2
var next_state : State = null
var knockback_timer : Timer




func _ready():
	# Wait until parent state machine initializes player reference
	await get_tree().process_frame
	if player:
		player.player_damaged.connect(_player_damaged)
	
	# Setup knockback timer
	knockback_timer = Timer.new()
	knockback_timer.wait_time = 0.3  # Knockback duration
	knockback_timer.one_shot = true
	knockback_timer.timeout.connect(_on_knockback_end)
	add_child(knockback_timer)
	pass


func _init() -> void:
	
	pass
func Enter() -> void:
	if !player:
		return
	
	
	player.animation_player.animation_finished.connect(_animation_finished)
	
	# Calculate knockback direction (away from damage source)
	direction = (player.global_position - hurt_box.global_position).normalized()
	player.UpdateAnimation("stun")
	player.velocity = direction * knockback_speed
	knockback_timer.start()
	
	player.make_invurnerable(invurnerable_duration)
	player.effect_animation_player.play("damaged")
	pass

func Exit() -> void:
	next_state = null
	if player.animation_player.is_connected("animation_finished", _animation_finished):
		player.animation_player.animation_finished.disconnect(_animation_finished)
	pass

func Process(_delta: float) -> State:
	return next_state

func Physics(_delta: float) -> State:
	# Gradually reduce knockback velocity
	player.velocity = player.velocity.move_toward(Vector2.ZERO, deacelerate_speed * _delta)
	player.move_and_slide()
	return null

func HandleInput(_event: InputEvent) -> State:
	return null

func _player_damaged(_hurt_box: HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.ChangeState(self)
	pass

func _animation_finished(_a : String) -> void:
	next_state = idle
	pass

func _on_knockback_end() -> void:
	# Optional: Add any knockback ending effects here
	pass
