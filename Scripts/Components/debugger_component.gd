extends VBoxContainer
class_name debugger

@export_category("Refrences")
@export var state_machine : state_machine
@export var hunger_component : hunger_component
@export var health_component : health_component
@export var thrist_component : thrist_component
@export var action_component : action_component

func _process(delta: float) -> void:
	%State.text = state_machine.current_state.name
	%Food.text = "Hunger : " + str(hunger_component.remaining_hunger) + " : " + hunger_component.hunger_states[hunger_component.remaining_hunger]
	%HP.text = "HP : " + str(health_component.health)
	%ActionQueue.text = str(action_component.queued_actions) + "  :  Curr - " + str(action_component.current_action)
	%Thrist.text = "Thirst : " + str(thrist_component.remaining_thrist) + " : " + thrist_component.thrist_states[thrist_component.remaining_thrist]
