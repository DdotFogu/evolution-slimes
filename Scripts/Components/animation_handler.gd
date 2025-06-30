@icon("res://Assets/IconGodotNode/node/icon_face.png")
extends Node
class_name animation_handler

@export_category("Refrences")
@export var state_machine: state_machine
@export var animation_player: AnimationPlayer

@export_category("Values")
@export var animtaion_dicts := {}
@export var enabled :  bool = true

func _process(delta: float) -> void:
	if !animtaion_dicts.has(state_machine.current_state.name): return 
	if !animation_player.current_animation != animtaion_dicts[state_machine.current_state.name] or !enabled: return
	animation_player.play(animtaion_dicts[state_machine.current_state.name])
