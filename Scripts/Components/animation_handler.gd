@icon("res://Assets/IconGodotNode/node/icon_face.png")
extends Node
class_name animation_handler

@export_category("Refrences")
@export var state_machine: state_machine
@export var animation_player: AnimationPlayer

@export_category("Values")
@export var animtaion_dicts := {}
@export var enabled :  bool = true

var _enabled : bool = false

func _ready() -> void:
	await animation_player.animation_finished
	await get_tree().create_timer(Global.rng.randf()).timeout
	_enabled = true

func _process(delta: float) -> void:
	if !animtaion_dicts.has(state_machine.current_state.name): return 
	if !animation_player.current_animation != animtaion_dicts[state_machine.current_state.name] or !enabled or !_enabled: return
	
	#print(animation_player.current_animation)
	animation_player.play(animtaion_dicts[state_machine.current_state.name])
