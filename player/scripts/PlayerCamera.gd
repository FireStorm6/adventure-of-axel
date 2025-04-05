class_name PlayerCamera
extends Camera2D

# Optional padding if needed (can be set to Vector2.ZERO)
var boundary_padding := Vector2(0, 0)

func _ready():
	LevelManager.TileMapBoundsChanged.connect(UpdateLimits)
	UpdateLimits(LevelManager.current_tilemap_bounds)

func UpdateLimits(bounds: Array[Vector2]) -> void:
	if bounds.size() < 2:
		return
	
	# Set each limit separately with optional padding
	limit_left = int(bounds[0].x) - boundary_padding.x
	limit_right = int(bounds[1].x) + boundary_padding.x
	limit_top = int(bounds[0].y) - boundary_padding.y
	limit_bottom = int(bounds[1].y) + boundary_padding.y
