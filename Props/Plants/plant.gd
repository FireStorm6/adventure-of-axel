class_name Plant extends Node2D

func _ready():
	$HitBoxProp.Damaged.connect(TakeDamage)
	pass

func TakeDamage(hurt_box: HurtBox) -> void:
	queue_free()
	pass
