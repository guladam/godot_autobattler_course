class_name DetailedTooltip
extends VBoxContainer

@onready var icon: TextureRect = %Icon
@onready var title: Label = %Title
@onready var description: RichTextLabel = %Description

var tooltip_data: DetailedTooltipData


func _ready() -> void:
	if not tooltip_data:
		return

	icon.texture = tooltip_data.texture
	title.text = tooltip_data.title
	description.text = tooltip_data.description
	description.custom_minimum_size.x = tooltip_data.min_size_x


class DetailedTooltipData:
	var texture: Texture
	var title: String
	var description: String
	var min_size_x: float = 0.0
