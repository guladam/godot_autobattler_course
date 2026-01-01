class_name TraitUI
extends PanelContainer

@export var trait_data: Trait : set = _set_trait_data
@export var active: bool : set = _set_active

@onready var trait_icon: TextureRect = %TraitIcon
@onready var active_units_label: Label = %ActiveUnitsLabel
@onready var trait_level_labels: RichTextLabel = %TraitLevelLabels
@onready var trait_label: Label = %TraitLabel


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("tooltip"):
		TooltipHandler.popup.show_popup(
			_get_trait_tooltip(),
			get_global_mouse_position()
		)
		accept_event()


func update(unique_units: int) -> void:
	active_units_label.text = str(unique_units)
	trait_level_labels.text = trait_data.get_levels_bbcode(unique_units)
	active = trait_data.is_active(unique_units)


func _get_trait_tooltip() -> DetailedTooltip:
	var new_tooltip := TooltipHandler.DETAILED_TOOLTIP.instantiate() as DetailedTooltip
	var data := new_tooltip.DetailedTooltipData.new()
	data.texture = trait_data.icon
	data.title = trait_data.name
	data.description = trait_data.description
	data.min_size_x = 150.0
	new_tooltip.tooltip_data = data
	return new_tooltip
  
func _set_trait_data(value: Trait) -> void:
	trait_data = value
	
	if value == null or not is_instance_valid(trait_label):
		return
	
	trait_icon.texture = trait_data.icon
	trait_label.text = trait_data.name


func _set_active(value: bool) -> void:
	active = value

	if active:
		modulate.a = 1.0
	else:
		modulate.a = 0.5
