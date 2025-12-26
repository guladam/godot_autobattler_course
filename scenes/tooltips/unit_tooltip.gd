class_name UnitTooltip
extends VBoxContainer

@export var stats: UnitStats:
	set(value):
		stats = value
		if stats and is_node_ready():
			tier_icon.stats = stats
			health_bar.stats = stats
			mana_bar.stats = stats
			unit_name.text = stats.name
			stats.changed.connect(_on_stats_changed)
			_on_stats_changed()

@export var item_handler: ItemHandler:
	set(value):
		item_handler = value
		if item_handler and is_node_ready():
			item_handler.items_changed.connect(_on_items_changed)
			_on_items_changed()

@onready var tier_icon: TierIcon = %TierIcon
@onready var unit_name: Label = %UnitName
@onready var health_bar: HealthBar = %HealthBar
@onready var health_label: Label = %HealthLabel
@onready var mana_bar: ManaBar = %ManaBar
@onready var mana_label: Label = %ManaLabel
@onready var item_container: HBoxContainer = %ItemContainer


func _ready() -> void:
	stats = self.stats
	item_handler = self.item_handler


func _on_stats_changed() -> void:
	health_label.text = "%s/%s" % [stats.health, stats.get_max_health()]
	mana_label.text = "%s/%s" % [stats.mana, stats.max_mana]


func _on_items_changed() -> void:
	for i: int in item_container.get_child_count():
		var item_ui := item_container.get_child(i) as ItemUI
		var item: Item = null
		
		if i < item_handler.equipped_items.size():
			item = item_handler.equipped_items[i]
		
		item_ui.item = item
