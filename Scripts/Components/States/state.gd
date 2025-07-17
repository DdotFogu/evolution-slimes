extends State
class_name eating

@export_category("Refrences")
@export var action_component: action_component
@export var hunger_component: hunger_component

var diet
var in_range_food

func _ready() -> void: diet = body.stat_sheet.diet_stats.diet.duplicate()

func enter(): eat(); body.velocity = Vector2.ZERO

func eat():
	#Find food within range and sort out non-edible
	if action_component.vision.has(diet.pick_random()): in_range_food = action_component.vision[diet.pick_random()]
	else: in_range_food = []
	var avalible_food : Array = in_range_food.duplicate()
	for food in avalible_food:
		if !food: return
		if food.edible == false:
			avalible_food.erase(food)
	if avalible_food.size() == 0: await get_tree().create_timer(0.1).timeout; Transitioned.emit(self, "Wander"); return
	else:
		var food_to_eat = avalible_food.pick_random()
		while true:
			if food_to_eat: break
			else: food_to_eat = avalible_food.pick_random()
		food_to_eat.eat(owner)
		
		if hunger_component.remaining_hunger == body.stat_sheet.diet_stats.hunger: await get_tree().create_timer(0.1).timeout; Transitioned.emit(self, "Wander")
		
		hunger_component.ate()

func exit(): Exited.emit();
