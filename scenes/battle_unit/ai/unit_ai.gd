class_name UnitAI
extends Node

@export var debug_label: Label
@export var enabled: bool: set = _set_enabled
@export var actor: BattleUnit

var fsm: FiniteStateMachine


func _ready() -> void:
	fsm = FiniteStateMachine.new()
	fsm.state_changed.connect(
		func(new_state: State):
			if not debug_label:
				return
			debug_label.text = new_state.get_script().get_global_name()
	)


func _set_enabled(value: bool) -> void:
	enabled = value
	
	if enabled:
		_start_chasing()
	else:
		fsm.change_state(null)


func _physics_process(delta: float) -> void:
	if not enabled:
		return

	fsm.state.physics_process(delta)


func _process(delta: float) -> void:
	if not enabled:
		return

	fsm.state.process(delta)


func _start_chasing() -> void:
	var chase_state := ChaseState.new(actor)
	chase_state.stuck.connect(_on_chase_state_stuck, CONNECT_ONE_SHOT)
	chase_state.target_reached.connect(_on_chase_state_target_reached, CONNECT_ONE_SHOT)
	fsm.change_state(chase_state)
	
	chase_state.chase()


func _on_chase_state_stuck() -> void:
	var stuck_state := StuckState.new(actor)
	stuck_state.timeout.connect(_start_chasing, CONNECT_ONE_SHOT)
	fsm.change_state(stuck_state)


func _on_chase_state_target_reached(target: BattleUnit) -> void:
	var aa_state := AutoAttackState.new(actor, target)
	aa_state.target_died.connect(_start_chasing, CONNECT_ONE_SHOT)
	aa_state.target_left_range.connect(_start_chasing, CONNECT_ONE_SHOT)
	fsm.change_state(aa_state)
