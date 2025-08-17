class_name OneTimeAnimation
extends Node

@export var animation_player: AnimationPlayer


func _ready() -> void:
	var owner_queue_free := animation_player.owner.queue_free.unbind(1)
	animation_player.animation_finished.connect(owner_queue_free)
