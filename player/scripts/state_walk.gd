class_name State_Walk extends State

@export var move_speed: float = 100.0
@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"
@export var walk_sound: AudioStream
@onready var audio: AudioStreamPlayer = $"../../Audio/SwordSwoosh"

func _init() -> void:
	pass  
## Entry state
func Enter() -> void:
	player.UpdateAnimation("walk")

	if walk_sound:
		audio.stream = walk_sound
		audio.pitch_scale = randf_range(0.9, 1.1)
		 
		if not audio.playing:  # ✅ Play only if not already playing
			audio.play()

## Exit state
func Exit() -> void:
	if audio.playing:
		audio.stop()  # ✅ Stop the sound when exiting the walk state

## Process update in state
func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		player.velocity = Vector2.ZERO  # ✅ Stop movement
		player.UpdateAnimation("idle")  # ✅ Switch to idle animation
		audio.stop()  # ✅ Stop walk sound
		return idle  # ✅ Transition to idle state

	player.velocity = player.direction * move_speed

	if player.SetDirection():
		player.UpdateAnimation("walk")
		
	if not audio.playing:  # ✅ Only play if it's not already playing
		audio.play()

	return null

func Physics(_delta: float) -> State:
	return null

func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
