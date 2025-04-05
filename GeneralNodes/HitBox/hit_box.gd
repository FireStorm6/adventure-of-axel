class_name HitBox extends Area2D

signal Damaged(hurt_box: HurtBox)  # Now emits the full HurtBox instance

func _ready():
	pass

func _process(delta):
	pass

func TakeDamage(hurt_box: HurtBox) -> void:
	print("TakeDamage")
	Damaged.emit(hurt_box)
