extends Resource
class_name StatSheet

@export_category("Stats")
@export var health_stats : HealthStats = HealthStats.new()
@export var action_stats : ActionStats = ActionStats.new()
@export var mating_stats : MatingStats = MatingStats.new()
@export var growth_stats : GrowthStats = GrowthStats.new()
@export var diet_stats : DietStats = DietStats.new()
@export var movement_stats : MovementStats = MovementStats.new()
@export var character_color : Color = Color.WHITE
