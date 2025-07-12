extends State
class_name wander

@export_category("Refrence")
@export var pathfinding_component: pathfinding_component
@export var growth_component: growth_component

@export_category("Values")
@export var wander_radius: float = 500.0
@export var timer_min : float = 1
@export var timer_max : float = 5
@export var goto_margin : float = 50.0

@onready var wander_timer: Timer = $wander_timer
@onready var fallback_timer: Timer = $fallback_timer
@onready var wander_position: Vector2 = body.global_position

var marker 

func _ready() -> void: 
	randomize()
	marker = Sprite2D.new(); marker.texture = preload("res://Assets/Sprites/Marker.png"); marker.visible = false; add_child(marker)

func enter() -> void:
	wander_timer.wait_time = Global.rng.randf_range(timer_min, timer_max); wander_timer.start()
	wander_position = body.global_position
	disable_timer(false)

func exit() -> void:
	disable_timer()
	fallback_timer.stop()
	body.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if wander_timer.paused == true: return
	
	if body.global_position.distance_to(wander_position) < goto_margin:
		body.velocity = body.velocity.lerp(Vector2.ZERO, body.stat_sheet.movement_stats.friction)
	else:
		var target_dir = pathfinding_component.direction_to_target(wander_position)
		body.velocity = body.velocity.lerp(target_dir * (body.stat_sheet.movement_stats.speed * growth_component.growth), body.stat_sheet.movement_stats.acceleration)
		
		%ArrowTest.rotation = target_dir.angle()
	
	body.move_and_slide()

#TODO FIX THE GET NERBY POSITION FUNC 
func new_wander_position(force_update : bool = false) -> void:
	if !force_update:
		if body.global_position.distance_to(wander_position) > goto_margin: return
	
	var new_target_location = pathfinding_component.get_nearby_position(wander_radius)
	while !pathfinding_component.los_check(new_target_location, body.global_position, 18):
		new_target_location = pathfinding_component.get_nearby_position(wander_radius)
	
	wander_position = new_target_location
	wander_timer.wait_time = Global.rng.randf_range(timer_min, timer_max)
	
	#Debug marker
	#marker.global_position = wander_position; marker.visible = true
	
	#Stuck Fallback
	#fallback_timer.start()

func disable_timer(boolean : bool = true): wander_timer.paused = boolean
