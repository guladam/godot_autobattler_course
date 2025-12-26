@tool
class_name PackedSprite2D
extends Sprite2D


@export var coordinates: Vector2i:
	set(value):
		coordinates = value
		region_rect.position = Vector2(coordinates) * Arena.CELL_SIZE


func get_texture_as_atlas() -> Texture:
	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = texture
	atlas_texture.region = region_rect
	return atlas_texture
