@icon("res://Assets/IconGodotNode/node/icon_brain.png")
extends Node
class_name state_machine

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func in_stun() -> bool:
	return false
	#if current_state is stun : return true
	#else: return false

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name, force_update : bool = false):
	if !force_update:
		if in_stun(): return false
	
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state
