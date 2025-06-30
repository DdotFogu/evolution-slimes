extends VBoxContainer
class_name debugger

@export_category("Refrences")
@export var state_machine : state_machine
@export var hunger_component : hunger_component
@export var health_component : health_component

func _process(delta: float) -> void:
	%State.text = state_machine.current_state.name
	%Food.text = "Hunger : " + str(hunger_component.remaining_hunger) + " : " + hunger_component.hunger_states[hunger_component.remaining_hunger]
	%HP.text = "HP : " + str(health_component.health)
