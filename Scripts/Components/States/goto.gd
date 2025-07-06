extends State
class_name goto

@export_category("Refrence")
@export var pathfinding_component: pathfinding_component

@export_category("Values")
@export var goto_margin : float = 100

var goto_position : Vector2

func physics_update(delta: float) -> void:
	if body.global_position.distance_to(goto_position) < goto_margin:
		exit()
	else:
		var target_dir = pathfinding_component.direction_to_target(goto_position)
		body.velocity = body.velocity.lerp(target_dir * body.stat_sheet.movement_stats.speed, body.stat_sheet.movement_stats.acceleration)
	
	body.move_and_slide()

func exit(): body.velocity = body.velocity.lerp(Vector2.ZERO, body.stat_sheet.movement_stats.friction); Exited.emit()
