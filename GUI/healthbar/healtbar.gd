extends TextureProgressBar

@onready var player: Player = get_node("../../Player")

func _ready():
	if player:
		player.hp_changed.connect(update_health)  # Connect signal
		update_health(player.hp)  # Initialize health

func update_health(new_hp: int):
	
	queue_redraw()  # Force UI update
