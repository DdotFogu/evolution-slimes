@icon("res://Assets/IconGodotNode/node/icon_scene.png")
extends vision_component
class_name action_component

@export_category("State")
@export var goto_state : goto
@export var eat_state : eating
@export var drink_state : drinking
@export var wander_state : wander
@export var explore_state : explore

@export_category("Refrences")
@export var vision_component : vision_component
@export var action_component : action_component

var queued_actions : Array[Dictionary]
var current_action : Dictionary
var in_action : bool = false

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
	if current_action: if Priority > current_action["Priority"]: print("diddy"); queued_actions.append(current_action); in_action = false; 
	
	queued_actions.append({
	"Action" : Action,
	"Priority" : Priority,
	})

func match_action(action_to_match : Dictionary): pass

func clear_curr_action(): in_action = false; current_action = {}

func goto(new_position : Vector2, margin : float = 100):
	if !goto_state: return
	
	goto_state.goto_margin = margin
	goto_state.goto_position = new_position
	goto_state.change_to_state()
