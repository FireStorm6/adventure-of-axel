class_name State extends Node
## state of player
static var player: Player
static var state_machine: PlayerStateMachine

func _ready():
	pass

## entry state
func Enter()-> void:
	pass

## exit state
func Exit()-> void:
	pass

## process update in state
func Process( _delta: float) -> State:
	return null

func Physics( _delta: float) -> State:
	return null

func HandleInput( _event: InputEvent) -> State:
	return null
