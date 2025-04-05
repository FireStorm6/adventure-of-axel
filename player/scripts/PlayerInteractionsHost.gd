class_name PlayerInteractionHost extends Node2D

@onready var player: Player = $".."





func _ready():
	player.DirectionChanged.connect(  UpdateDirection)
	pass



func UpdateDirection(new_direction: Vector2) -> void:
	match new_direction:
		Vector2.DOWN:
			transform.origin = Vector2(0, 0)
		Vector2.UP:
			transform.origin = Vector2(0, -47)
		Vector2.RIGHT:
			transform.origin = Vector2(24, -25)
		Vector2.LEFT:
			transform.origin = Vector2(-24, -25)
		_:
			transform.origin = Vector2(0, 0) 
	pass
