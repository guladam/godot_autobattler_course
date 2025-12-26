class_name UnitTooltipHandler
extends Node

@export var unit: Area2D


func _ready() -> void:
	unit.input_event.connect(_on_input_event)


func _get_tooltip() -> UnitTooltip:
	if not (unit is Unit or unit is BattleUnit):
		return
		
	var new_tooltip := TooltipHandler.UNIT_TOOLTIP.instantiate() as UnitTooltip
	new_tooltip.stats = unit.stats
	new_tooltip.item_handler = unit.item_handler
	return new_tooltip


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("tooltip"):
		TooltipHandler.popup.show_popup(
			_get_tooltip(),
			unit.get_global_mouse_position()
		)
		get_viewport().set_input_as_handled()
