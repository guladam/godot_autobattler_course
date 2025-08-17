class_name SellPortal
extends Area2D

@export var unit_pool: UnitPool
@export var player_stats: PlayerStats
@export var sell_sound: AudioStream

@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter
@onready var gold: HBoxContainer = %Gold
@onready var gold_label: Label = %GoldLabel
@onready var flip_sprite: FlipSprite = $FlipSprite

var current_unit: Unit


func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		setup_unit(unit)


func _process(_delta: float) -> void:
	if not current_unit:
		return
	
	flip_sprite.flip_sprite_towards(current_unit.global_position)


func setup_unit(unit: Unit) -> void:
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))
	unit.quick_sell_pressed.connect(_sell_unit.bind(unit))


func _sell_unit(unit: Unit) -> void:
	player_stats.gold += unit.stats.get_gold_value()
	# TODO give items back to item pool
	unit_pool.add_unit(unit.stats)
	
	unit.queue_free()
	SFXPlayer.play(sell_sound)


func _on_unit_dropped(_starting_position: Vector2, unit: Unit) -> void:
	if unit and unit == current_unit:
		_sell_unit(unit)


func _on_area_entered(unit: Unit) -> void:
	current_unit = unit
	outline_highlighter.highlight()
	gold_label.text = str(unit.stats.get_gold_value())
	gold.show()


func _on_area_exited(unit: Unit) -> void:
	if unit and unit == current_unit:
		current_unit = null
	
	outline_highlighter.clear_highlight()
	gold.hide()
