@tool
class_name BenchItem
extends Area2D

@export var item: Item : set = _set_item

@onready var packed_sprite_2d: PackedSprite2D = $PackedSprite2D
@onready var drag_and_drop: DragAndDrop = $DragAndDrop

var hovered_unit: Area2D


func _ready() -> void:
	if not Engine.is_editor_hint():
		area_entered.connect(_on_area_entered)
		area_exited.connect(_on_area_exited)
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)
		drag_and_drop.dropped.connect(_on_dropped)
<<<<<<< Updated upstream
=======
		input_event.connect(_on_input_event)


func _get_tooltip() -> DetailedTooltip:
	var new_tooltip := TooltipHandler.DETAILED_TOOLTIP.instantiate() as DetailedTooltip
	var data := new_tooltip.DetailedTooltipData.new()
	data.texture = packed_sprite_2d.get_texture_as_atlas()
	data.title = item.name
	data.description = item.description
	new_tooltip.tooltip_data = data
	return new_tooltip
>>>>>>> Stashed changes


func _set_item(new_item: Item) -> void:
	item = new_item
	
	if new_item == null or not is_instance_valid(drag_and_drop):
		return
	
	packed_sprite_2d.coordinates = item.sprite_coordinates


func _on_area_entered(area: Area2D) -> void:
	if area is Unit or area is BattleUnit:
		hovered_unit = area


func _on_area_exited(_area: Area2D) -> void:
	hovered_unit = null


func _on_drag_canceled(starting_position: Vector2) -> void:
	global_position = starting_position


func _on_dropped(starting_position: Vector2) -> void:
	if hovered_unit:
		var item_handler: ItemHandler = hovered_unit.item_handler
		if item_handler and item_handler.add_item(item):
			queue_free()
			return
	
	global_position = starting_position
