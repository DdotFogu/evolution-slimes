extends State
class_name eating

@export_category("Refrences")
@export var action_component: action_component
@export var hunger_component: hunger_component

@onready var eat_timer : Timer = %Eat

signal finished

func enter():
	action_component.enabled = true
	eat_timer.start()

func eat():
	#Find food within range and sort out non-edibles
	var in_range_food = action_component.sort_objects(["Food"])
	var avalible_food : Array = in_range_food["Food"]
	for food in avalible_food:
		pass
		if food.edible == false:
			avalible_food.erase(food)
	
	if avalible_food.size() == 0: exit()
	else: 
		var food_to_eat = avalible_food.pick_random()
		hunger_component.decay_hunger(-food_to_eat.hunger_restoration)
		food_to_eat.queue_free()
		
		if hunger_component.remaining_hunger == body.stat_sheet.hunger: finished.emit(); exit()

func exit():
	action_component.enabled = false
	hunger_component.looking_for_food = false
	eat_timer.stop()
