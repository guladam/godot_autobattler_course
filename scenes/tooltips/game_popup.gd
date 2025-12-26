class_name GamePopup
extends PanelContainer

@onready var content_container: MarginContainer = %ContentContainer


func _ready() -> void:
	_clear()


func _input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event.is_action_pressed("select") or event.is_action_pressed("tooltip"):
		hide_popup()


func _clear() -> void:
	for node: Control in content_container.get_children():
		node.queue_free()


func _get_position(mouse_pos: Vector2i) -> Vector2i:
	var screen_size := Vector2i(get_tree().root.get_visible_rect().size)
	var max_pos := screen_size - Vector2i(size)
	var final_x: int = clampi(mouse_pos.x, 0, max_pos.x)
	var final_y: int = clampi(mouse_pos.y, 0, max_pos.y)

	return Vector2i(final_x, final_y)


func show_popup(content: Control, pos: Vector2i) -> void:
	content_container.add_child(content)
	await get_tree().process_frame
	reset_size()
	global_position = _get_position(pos)
	mouse_filter = Control.MOUSE_FILTER_STOP
	show()


func hide_popup() -> void:
	_clear()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	hide()


func center() -> void:
	var screen_size := get_tree().root.get_visible_rect().size
	global_position = (screen_size / 2) - (size / 2)
