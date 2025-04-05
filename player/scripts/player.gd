class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO
const Dir_4=[ Vector2.RIGHT ,Vector2.DOWN,Vector2.LEFT,Vector2.UP]
var invurnerable : bool =false
var hp: int =10
var max_hp : int = 10

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hit_box: HitBox = $HitBox
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var playground: Node2D = $".."
#@onready var health_bar: TextureProgressBar = $"../HealthBarUi/TextureProgressBar"
@onready var health_bar: TextureProgressBar = $TextureProgressBar
@onready var health_label: Label = $"../HealthBarUi/TextureProgressBar/health_label"

@onready var health_bar_big: TextureProgressBar = $"../HealthBarUi/TextureProgressBar"




signal hp_changed(new_hp: int)


signal DirectionChanged( new_direction : Vector2)
signal player_damaged (hurt_box:HurtBox)

func _ready():
	PlayerManager.player = self
	state_machine.Intialize(self)
	hit_box.Damaged.connect(_take_damage)
	update_hp(99)
	pass
func _process(_delta):
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	direction = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	).normalized()
	pass

func _physics_process(_delta):
	move_and_slide()

func SetDirection() -> bool:
	
	if direction == Vector2.ZERO:
		return false  # No movement, return early
	
	var direction_id:  int = int( round( ( direction + cardinal_direction*0.1).angle() / TAU * Dir_4.size()))
	var new_dir=Dir_4[direction_id]
	if new_dir != cardinal_direction:
		cardinal_direction = new_dir
	
	DirectionChanged.emit(new_dir)
	# Always update sprite direction when moving left or right
	if cardinal_direction == Vector2.LEFT:
		sprite_2d.scale.x = -1  # Flip left
	elif cardinal_direction == Vector2.RIGHT:
		sprite_2d.scale.x = 1   # Face right

	return true



func UpdateAnimation(state : String) -> void:
	animation_player.play(state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"


func _take_damage (hurt_box: HurtBox) -> void:
	if invurnerable == true:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		print("Player damaged! Current HP: ", hp)  # Print when player is damaged
		player_damaged.emit(hurt_box)
	else:
		print("Player is dead!")  # Print when player is dead
		player_damaged.emit(hurt_box)
		update_hp(99)  # Reset health (optional)
	pass



func update_hp(delta: int) -> void:
	hp = clamp(hp + delta, 0, max_hp)
	print("Player's current HP: ", hp)
	health_bar.value = (float(hp) / max_hp) * 100 
	health_bar_big.value = (float(hp) / max_hp) * 100 
	health_label.text = str(hp) + "/" + str(max_hp)# Directly update the health bar
	hp_changed.emit(hp)  # Emit signal when HP updates

#func update_hp(delta : int) -> void:
	#hp = clamp(hp + delta, 0, max_hp)
	#
	#print("Player's current HP: ", hp) 
	#emit_signal("update_hp")


func make_invurnerable(_duration : float =1.0)->void:
	invurnerable =true
	hit_box.monitoring=false
	await get_tree().create_timer(_duration).timeout
	
	invurnerable=false
	hit_box.monitoring=true
	pass
