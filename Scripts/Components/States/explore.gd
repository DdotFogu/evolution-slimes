extends State
class_name explore

@export_category("Refrence")
@export var growth_component : growth_component

var explore_direction = Vector2(0, 0)
var last_direction 
@onready var explore_ray: ShapeCast2D = %ExploreRay
@onready var explore_timer: Timer = $"Explore Timer"

func _ready() -> void:explore_timer.paused = true

func enter(): randomize(); explore_ray.enabled = true ;explore_ray.visible = true; explore_timer.paused = false; random_direction()

func random_direction():
	last_direction = explore_direction; explore_direction = Vector2.ZERO
	while explore_direction == Vector2.ZERO or explore_direction == last_direction: 
		explore_direction = Vector2(Global.rng.randi_range(-1, 1), Global.rng.randi_range(-1, 1))
	explore_ray.target_position = explore_direction * 200

func physics_update(delta: float) -> void:
	if explore_ray.is_colliding(): random_direction()
	
	explore_timer.wait_time = 10 + Global.rng.randf_range(-5, 5)
	
	body.velocity = body.velocity.lerp(explore_direction * (body.stat_sheet.movement_stats.speed * growth_component.growth), body.stat_sheet.movement_stats.acceleration)
	body.move_and_slide()

func exit(): explore_ray.enabled = false; explore_ray.visible = false; explore_timer.paused = true
