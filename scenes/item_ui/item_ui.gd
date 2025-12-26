class_name ItemUI
extends TextureRect

@export var tooltip_offset: Vector2i
@export var item: Item:
	set(value):
		item = value
		
		if not is_node_ready():
			return
		
		if not item:
			icon.hide()
			return
		
		icon.texture.region.position = Vector2(item.sprite_coordinates) * Arena.CELL_SIZE
		icon.show()


@onready var icon: TextureRect = $Icon


func _ready() -> void:
	item = self.item
	mouse_entered.connect(_show_tooltip)
	mouse_exited.connect(TooltipHandler.popup_2.hide_popup)


func _get_item_tooltip() -> DetailedTooltip:
	var new_tooltip := TooltipHandler.DETAILED_TOOLTIP.instantiate() as DetailedTooltip
	var data := new_tooltip.DetailedTooltipData.new()
	data.texture = icon.texture.duplicate()
	data.title = item.name
	data.description = item.description
	new_tooltip.setup(data)
	return new_tooltip


func _show_tooltip() -> void:
	if not item or TooltipHandler.popup_2.visible:
		return 

	TooltipHandler.popup_2.show_popup(
		_get_item_tooltip(),
		global_position + Vector2(size.x + tooltip_offset.x, tooltip_offset.y)
	)
	get_viewport().set_input_as_handled()
