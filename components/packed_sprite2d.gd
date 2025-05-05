@tool
class_name PackedSprite2D
extends Sprite2D


@export var coordinates: Vector2i:
	set(value):
		coordinates = value
		region_rect.position = Vector2(coordinates) * Arena.CELL_SIZE
