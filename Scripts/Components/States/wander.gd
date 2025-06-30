extends State
class_name wander

@export_category("Refrence")
@export var pathfinding_component: pathfinding_component

@export_category("Values")
@export var wander_radius: float = 500.0
@export var minimum_wander: float = 300.0
@export var timer_min : float = 1
@export var timer_max : float = 5
@export var goto_margin : float = 50.0

@onready var wander_timer: Timer = $Timer
@onready var wander_position: Vector2 = body.global_position

func enter() -> void:
	wander_timer.start()

func exit() -> void:
	wander_timer.stop()
	body.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if wander_timer.paused == true: return
	
	if body.global_position.distance_to(wander_position) < goto_margin:
		state_machine.current_state = $"../Idle"
	else:
		var target_dir = pathfinding_component.direction_to_target(wander_position)
		body.velocity = body.velocity.lerp(target_dir * body.stat_sheet.speed, body.stat_sheet.acceleration)
	
	body.move_and_slide()

func new_wander_position() -> void:
	if body.global_position.distance_to(wander_position) > goto_margin: return
	
	state_machine.current_state = self
	
	var new_target_location = pathfinding_component.get_nearby_position(wander_radius)
	#If the distance to new location is less than allowed minimun then reroll for new target
	var attempts : int = 0
	while body.global_position.distance_to(new_target_location) < minimum_wander:
		new_target_location = pathfinding_component.get_nearby_position(wander_radius)
		
		attempts += 1
		if attempts > 50: break
	
	wander_position = new_target_location
	wander_timer.wait_time = Global.rng.randf_range(timer_min, timer_max)

func disable_timer(boolean : bool = true):
	wander_timer.paused = boolean
