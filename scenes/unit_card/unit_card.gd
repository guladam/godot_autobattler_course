class_name UnitCard
extends Button

signal unit_bought(unit: UnitStats)

const HOVER_BORDER_COLOR := Color("fafa82")

@export var player_stats: PlayerStats
@export var unit_stats: UnitStats : set = _set_unit_stats

@onready var traits: Label = %Traits
@onready var bottom: Panel = %Bottom
@onready var unit_name: Label = %UnitName
@onready var gold_cost: Label = %GoldCost
@onready var border: Panel = %Border
@onready var empty_placeholder: Panel = %EmptyPlaceholder
@onready var unit_icon: TextureRect = %UnitIcon
@onready var border_sb: StyleBoxFlat = border.get_theme_stylebox("panel")
@onready var bottom_sb: StyleBoxFlat = bottom.get_theme_stylebox("panel")

var bought := false
var border_color: Color


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _set_unit_stats(value: UnitStats) -> void:
	unit_stats = value
	
	if not is_node_ready():
		await ready

	if not unit_stats:
		empty_placeholder.show()
		disabled = true
		bought = true
		return

	border_color = UnitStats.RARITY_COLORS[unit_stats.rarity]
	border_sb.border_color = border_color
	bottom_sb.bg_color = border_color
	traits.text = "\n".join(Trait.get_trait_names(unit_stats.traits))
	unit_name.text = unit_stats.name
	gold_cost.text = str(unit_stats.gold_cost)
	unit_icon.texture.region.position = Vector2(unit_stats.skin_coordinates) * Arena.CELL_SIZE


func _on_player_stats_changed() -> void:
	if not unit_stats:
		return

	var has_enough_gold := player_stats.gold >= unit_stats.gold_cost
	disabled = not has_enough_gold
	
	if has_enough_gold or bought:
		modulate = Color(Color.WHITE, 1.0)
	else:
		modulate = Color(Color.WHITE, 0.5)


func _on_pressed() -> void:
	if bought:
		return
	
	bought = true
	empty_placeholder.show()
	player_stats.gold -= unit_stats.gold_cost
	unit_bought.emit(unit_stats)


func _on_mouse_entered() -> void:
	if not disabled:
		border_sb.border_color = HOVER_BORDER_COLOR


func _on_mouse_exited() -> void:
	border_sb.border_color = border_color
