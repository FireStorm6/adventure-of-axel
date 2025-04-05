class_name State_Attack extends State


var attacking : bool =false
@onready var walk: State = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var idle: State = $"../Idle"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"

@export var attack_sound : AudioStream

@onready var audio: AudioStreamPlayer = $"../../Audio/SwordSwoosh"
@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"


@export_range(1,20,0.5) var deacelerate_speed : float = 5.0

func _init() -> void:
	pass  
## entry state
func Enter()-> void:
	
	player.UpdateAnimation("attack")
	attack_anim.play("attack_" + player.AnimDirection())
	animation_player.animation_finished.connect(EndAttack)
	
	audio.stream= attack_sound
	audio.pitch_scale=randf_range(0.9 , 1.1)
	audio.play()
	attacking = true
	
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurt_box.monitoring = true
	pass

## exit state
func Exit()-> void:
	animation_player.animation_finished.disconnect(EndAttack)
	hurt_box.monitoring = false
	pass

## process update in state
func Process( _delta: float) -> State:
	player.velocity -= player.velocity * deacelerate_speed * _delta
	
	if attacking== false:
		if player.direction== Vector2.ZERO:
			return idle
		else:
			return walk
	return null

func Physics( _delta: float) -> State:
	return null

func HandleInput( _event: InputEvent) -> State:
	return null


func EndAttack( _newAnimName : String)-> void:
	attacking = false
