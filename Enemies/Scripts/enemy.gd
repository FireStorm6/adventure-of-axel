class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged(hurt_box: HurtBox)  # Now emits the full HurtBox
signal enemy_destroyed()

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp: int = 3

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
var player: Player
var Invurnerable: bool = false
var last_hurt_box: HurtBox  # Store last attack details

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

func _ready():
	state_machine.initialize(self)
	player = PlayerManager.player
	hit_box.Damaged.connect(_take_damage)
	pass

func _process(_delta):
	pass

func _physics_process(_delta):
	move_and_slide()

func Set_Direction(_new_direction: Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false  
	
	var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_dir = DIR_4[direction_id]
	if new_dir != cardinal_direction:
		cardinal_direction = new_dir
	
	direction_changed.emit(new_dir)

	if cardinal_direction == Vector2.LEFT:
		sprite_2d.scale.x = -1  
	elif cardinal_direction == Vector2.RIGHT:
		sprite_2d.scale.x = 1   

	return true

func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())

func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"



func _take_damage(hurt_box: HurtBox) -> void:
	if Invurnerable or hp <= 0:
		return
	
	hp -= hurt_box.damage
	print("%s took damage (HP: %d)" % [name, hp])

	enemy_damaged.emit(hurt_box)  

	if hp <= 0:
		hp = 0  
		last_hurt_box = hurt_box  # Store the last HurtBox before switching state
		print("%s triggering destruction" % name)
		state_machine.change_state(state_machine.get_node("Destroy"))
	else:
		state_machine.change_state(state_machine.get_node("Stun"))
