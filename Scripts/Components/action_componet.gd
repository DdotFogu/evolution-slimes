@icon("res://Assets/IconGodotNode/node/icon_scene.png")
extends vision_component
class_name action_component

@export_category("States")
@export var states : Dictionary = {
	"goto" : null,
	"eat" : null,
	"drink" : null,
	"wander" : null,
	"explore" : null,
	"idle" : null,
	"mate" : null,
}

@export_category("Refrences")
@export var vision_component : vision_component
@export var action_component : action_component
@export var mating_component : mating_component

var queued_actions : Array[Dictionary]
var current_action : Dictionary
var in_action : bool = false

func _ready() -> void: vision_node.get_node("Range").shape = CircleShape2D.new()

func _process(delta: float) -> void:
	vision_range = owner.stat_sheet.action_stats.action_range
	if enabled:
		vision_node.get_node("Range").shape.radius = vision_range
		vision_node.collision_mask = searchable_items
		vision = find_objects()
	
	if in_action or queued_actions.size() == 0: return
	in_action = true; queued_actions.sort_custom(func(a, b): return a.Priority > b.Priority)
	current_action = queued_actions[0]
	queued_actions.remove_at(0)
	match_action(current_action)

func queue_up_action(Action : String, Priority : float = 0.01):
	for dict in queued_actions: 
		if dict["Action"] == Action: 
			if dict.has("Priority"): if dict["Priority"] < Priority: dict["Priority"] = Priority
			return
	if current_action: if Action == current_action["Action"]: return
	if current_action: if Priority > current_action["Priority"]: queued_actions.append(current_action); clear_curr_action(); 
	
	queued_actions.append({
	"Action" : Action,
	"Priority" : Priority,
	})

func match_action(action_to_match : Dictionary): pass

func clear_curr_action(): in_action = false; current_action = {}

func get_state(state_name : String):
	return get_node(states[state_name])

func goto(new_position : Vector2, margin : float = 100):
	if !get_state("goto"): return
	
	get_state("goto").goto_margin = margin
	get_state("goto").goto_position = new_position
	get_state("goto").change_to_state()
