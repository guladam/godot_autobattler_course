class_name UnitAbility
extends Node2D

signal ability_cast_finished

@export var caster: BattleUnit
@export var sound: AudioStream


func _ready() -> void:
	add_to_group("unit_abilities")


func use() -> void:
	SFXPlayer.play(sound)
	ability_cast_finished.emit()
