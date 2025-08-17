@tool
@icon("res://assets/icons/hitbox_icon.svg")
class_name HitBox
extends Area2D

signal hit

@export var damage: int


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hurtbox: Area2D) -> void:
	if not hurtbox is HurtBox:
		return
	
	hit.emit()
