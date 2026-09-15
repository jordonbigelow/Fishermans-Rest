class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State

func _ready() -> void:
	await owner.ready

	if initial_state == null:
		push_error("StateMachine has no initial state assigned.")
		return

	current_state = initial_state
	current_state.enter()


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func _process(delta: float) -> void:
	current_state.update(delta)


func transition_to(target_state_name: String) -> void:
	var target_state := get_node_or_null(target_state_name) as State
	if target_state == null:
		push_error("State '%s' not found." % target_state_name)
		return
	if target_state == current_state:
		return

	current_state.exit()
	current_state = target_state
	current_state.enter()
