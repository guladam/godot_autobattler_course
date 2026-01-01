class_name BenchItems
extends Node2D

@onready var scene_spawner: SceneSpawner = $SceneSpawner

var slots: Array[Marker2D]


func _ready() -> void:
	for node: Node in get_children():
		if node is Marker2D:
			slots.append(node)
	
	var items := [
		preload("uid://cp4xakg8px5n6"),
		preload("uid://dw168maw12qh3"),
		preload("uid://daypjmkkj5hgb")
	]
	for _i: int in slots.size():
		add_item(items.pick_random())


func return_items_from_unit(unit: Unit) -> void:
	for item: Item in unit.item_handler.equipped_items:
		if item:
			add_item(item)


func add_item(item: Item) -> void:
	var slot := _get_first_available_slot()
	
	if not slot:
		print("No empty space for item!")
	
	var bench_item := scene_spawner.spawn_scene(slot)
	bench_item.item = item


func _get_first_available_slot() -> Marker2D:
	for slot: Marker2D in slots:
		if slot.get_child_count() == 0:
			return slot
	
	return null
