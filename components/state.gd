class_name State
extends RefCounted

var actor: Node


func _init(new_actor: Node) -> void:
	actor = new_actor


func physics_process(_delta: float) -> void:
	pass


func process(_delta: float) -> void:
	pass


func enter() -> void:
	pass


func exit() -> void:
	pass
