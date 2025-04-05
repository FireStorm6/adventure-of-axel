class_name HurtBox extends Area2D

@export var damage: int = 1

func _ready():
	area_entered.connect(AreaEnetered)
	pass

func _process(delta):
	pass

func AreaEnetered(a: Area2D) -> void:
	if a is HitBox:
		a.TakeDamage(self)  # Pass full HurtBox instance
	pass
