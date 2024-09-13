class_name DragAndDrop
extends Node

signal drag_canceled(starting_position: Vector2)
signal drag_started
signal dropped(starting_position: Vector2)

@export var enabled: bool = true
@export var target: Area2D

var starting_position: Vector2
var offset := Vector2.ZERO
var dragging := false


func _ready() -> void:
	assert(target, "No target set for DragAndDrop Component!")
	target.input_event.connect(_on_target_input_event.unbind(1))


func _process(_delta: float) -> void:
	if dragging and target:
		target.global_position = target.get_global_mouse_position() + offset


func _end_dragging() -> void:
	dragging = false
	target.remove_from_group("dragging")
	target.z_index = 0


func _cancel_dragging() -> void:
	_end_dragging()
	drag_canceled.emit(starting_position)


func _start_dragging() -> void:
	dragging = true
	starting_position = target.global_position
	target.add_to_group("dragging")
	target.z_index = 99
	offset = target.global_position - target.get_global_mouse_position()
	drag_started.emit()


func _drop() -> void:
	_end_dragging()
	dropped.emit(starting_position)
	

func _on_target_input_event(_viewport: Node, event: InputEvent) -> void:
	if not enabled:
		return

	var dragging_object := get_tree().get_first_node_in_group("dragging")
	
	if not dragging and dragging_object:
		return
	
	if dragging and event.is_action_pressed("cancel_drag"):
		_cancel_dragging()
	elif not dragging and event.is_action_pressed("select"):
		_start_dragging()
	elif dragging and event.is_action_released("select"):
		_drop()
