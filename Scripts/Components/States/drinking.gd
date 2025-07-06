extends State
class_name drinking

@export_category("Refrences")
@export var action_component: action_component
@export var thrist_component : thrist_component

func enter(): drink(); body.velocity = Vector2.ZERO

func drink():
	thrist_component.decay_thrist(-body.stat_sheet.diet_stats.thrist)
	
	if thrist_component.remaining_thrist == body.stat_sheet.diet_stats.thrist: await get_tree().create_timer(0.1).timeout; Transitioned.emit(self, "Wander")
