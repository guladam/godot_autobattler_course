class_name Shop
extends Control

signal unit_bought(unit: UnitStats)

@export var unit_pool: UnitPool
@export var player_stats: PlayerStats
@export var unit_grids: Array[UnitGrid]

@onready var shop_cards: VBoxContainer = %ShopCards
@onready var card_spawner: SceneSpawner = $SceneSpawner


func _ready() -> void:
	unit_pool.generate_unit_pool()
	
	for child: Node in shop_cards.get_children():
		child.queue_free()

	_roll_units()


func _roll_units() -> void:
	for i in 5:
		var rarity := player_stats.get_random_rarity_for_level()
		var new_card := card_spawner.spawn_scene(shop_cards) as UnitCard
		new_card.unit_stats = unit_pool.get_random_unit_by_rarity(rarity)
		new_card.unit_grids = unit_grids
		new_card.update()
		new_card.unit_bought.connect(_on_unit_bought)


func _put_back_remaining_to_pool() -> void:
	for unit_card: UnitCard in shop_cards.get_children():
		if not unit_card.bought:
			unit_pool.add_unit(unit_card.unit_stats)
		
		unit_card.queue_free()


func _on_unit_bought(unit: UnitStats) -> void:
	unit_bought.emit(unit)


func _on_reroll_button_pressed() -> void:
	_put_back_remaining_to_pool()
	_roll_units()
