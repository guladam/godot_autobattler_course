class_name TraitUI
extends PanelContainer

@export var trait_data: Trait : set = _set_trait_data
@export var active: bool : set = _set_active

@onready var trait_icon: TextureRect = %TraitIcon
@onready var active_units_label: Label = %ActiveUnitsLabel
@onready var trait_level_labels: RichTextLabel = %TraitLevelLabels
@onready var trait_label: Label = %TraitLabel


func update(units: Array[Unit]) -> void:
	var unique_units := trait_data.get_unique_unit_count(units)
	active_units_label.text = str(unique_units)
	trait_level_labels.text = trait_data.get_levels_bbcode(unique_units)
	active = trait_data.is_active(unique_units)


func _set_trait_data(value: Trait) -> void:
	if not is_node_ready():
		await ready

	trait_data = value
	trait_icon.texture = trait_data.icon
	trait_label.text = trait_data.name


func _set_active(value: bool) -> void:
	active = value

	if active:
		modulate.a = 1.0
	else:
		modulate.a = 0.5
