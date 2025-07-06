extends State
class_name explore

var explore_direction = Vector2(0, 0)
var last_direction 
@onready var explore_ray: ShapeCast2D = %ExploreRay

func enter(): randomize(); explore_ray.enabled = true ;explore_ray.visible = true;random_direction()

func random_direction():
	last_direction = explore_direction; explore_direction = Vector2.ZERO
	while explore_direction == Vector2.ZERO or explore_direction == last_direction: 
		explore_direction = Vector2(Global.rng.randi_range(-1, 1), Global.rng.randi_range(-1, 1))
	explore_ray.target_position = explore_direction * 200

func physics_update(delta: float) -> void:
	if explore_ray.is_colliding(): random_direction()
	
	body.velocity = body.velocity.lerp(explore_direction * body.stat_sheet.movement_stats.speed, body.stat_sheet.movement_stats.acceleration)
	body.move_and_slide()

func exit(): explore_ray.enabled = false; explore_ray.visible = false
