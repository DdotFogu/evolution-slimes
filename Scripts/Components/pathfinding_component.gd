@icon("res://Assets/IconGodotNode/node/icon_search.png")
extends Node2D
class_name pathfinding_component

var los := ShapeCast2D.new()
var body : CharacterBody2D

# Danger cooldown for each direction (index = ray index)
var danger_cooldown : Array[float] = []
const DANGER_COOLDOWN_TIME := 0.5  # seconds

func _ready() -> void:
	body = get_parent()
	los.shape = CircleShape2D.new()
	los.shape.radius = 5
	los.modulate.a = 0
	add_child(los)

	# Initialize cooldowns
	var ray_count := %ProductRays.get_child_count()
	danger_cooldown.resize(ray_count)
	for i in range(ray_count):
		danger_cooldown[i] = 0.0

func _process(delta: float) -> void:
	# Decay danger cooldowns
	for i in range(danger_cooldown.size()):
		danger_cooldown[i] = max(0.0, danger_cooldown[i] - delta)

func los_check(target_pos: Vector2, new_global_position: Vector2 = owner.global_position, mask: int = 1) -> bool:
	los.visible = true
	los.global_position = new_global_position
	los.collision_mask = mask
	los.target_position = target_pos - get_parent().global_position
	los.force_shapecast_update()
	return los.get_collider(0) == null

func direction_to_target(target_pos: Vector2, dir_array := [
	Vector2(1, 0), Vector2(1, -1), Vector2(0, -1), Vector2(-1, -1),
	Vector2(-1, 0), Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)]
) -> Vector2:
	var target_direction = body.global_position.direction_to(target_pos).normalized()
	
	var intrest_vector : Array[Dictionary] = []
	for dir in dir_array:
		intrest_vector.append({
			"Direction": dir.normalized(),
			"Intrest": dir.normalized().dot(target_direction)
		})
	
	var danger : Array[float] = []
	for i in range(dir_array.size()):
		danger.append(0.0)
	
	var count := 0
	for raycast : RayCast2D in %ProductRays.get_children():
		raycast.force_raycast_update()
		if raycast.is_colliding():
			# Set danger and start cooldown for this direction and neighbors
			danger[count] += 10.0
			danger_cooldown[count] = DANGER_COOLDOWN_TIME
		count += 1
	
	for i in range(intrest_vector.size()):
		# Apply cooldown penalty
		var cooldown_penalty := 10.0 if danger_cooldown[i] > 0.0 else 0.0
		intrest_vector[i]["Intrest"] = roundf(intrest_vector[i]["Intrest"] - danger[i] - cooldown_penalty)
	
	# Sort by highest interest
	intrest_vector.sort_custom(func(a, b): return a["Intrest"] > b["Intrest"])
	return intrest_vector[0]["Direction"]

func get_nearby_position(radius: float = 200.0) -> Vector2:
	return Vector2(
		Global.rng.randf_range(-radius, radius),
		Global.rng.randf_range(-radius, radius)
	) + global_position
