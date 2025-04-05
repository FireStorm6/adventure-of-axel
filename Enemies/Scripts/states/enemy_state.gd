class_name EnemyState extends Node


var enemy :Enemy
var state_machine : EnemyStateMachine


func init()->void:
	pass


func Enter()-> void:
	pass

## exit state
func Exit()-> void:
	pass

## process update in state
func Process( _delta: float) -> EnemyState:
	
	return null

func Physics( _delta: float) -> EnemyState:
	return null
