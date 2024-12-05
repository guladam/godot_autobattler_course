class_name Shop
extends Control

signal unit_bought(unit: UnitStats)

@export var player_stats: PlayerStats

@onready var shop_cards: VBoxContainer = %ShopCards


func _ready() -> void:
	for unit_card: UnitCard in shop_cards.get_children():
		unit_card.unit_bought.connect(_on_unit_bought)


func _on_unit_bought(unit: UnitStats) -> void:
	unit_bought.emit(unit)


func _on_reroll_button_pressed() -> void:
	print("reroll units to new ones!")
