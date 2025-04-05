class_name LevelTileMap
extends TileMap

func _ready():
	LevelManager.ChangeTilemapBounds(GetTileMapBounds())

func GetTileMapBounds() -> Array[Vector2]:
	var used_rect := get_used_rect()
	var tile_size := Vector2(tile_set.tile_size)
	var tilemap_pos := global_position
	
	# Calculate each boundary separately in world coordinates
	var left := tilemap_pos.x + (used_rect.position.x * tile_size.x)
	var right := tilemap_pos.x + (used_rect.end.x * tile_size.x)
	var top := tilemap_pos.y + (used_rect.position.y * tile_size.y)
	var bottom:= tilemap_pos.y + (used_rect.end.y * tile_size.y)
	
	# Return as [top-left, bottom-right] coordinates
	return [Vector2(left, top), Vector2(right, bottom)]
