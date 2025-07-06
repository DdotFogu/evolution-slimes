extends Node
class_name State

signal Transitioned
signal Entered
signal Exited

@onready var state_machine = get_parent()
@onready var body = owner

func enter():
	pass

func exit():
	Exited.emit()

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func change_to_state():
	#print("CHANGED TO " + str(self.name))
	state_machine.current_state.Transitioned.emit(state_machine.current_state, self.name)
	
	if state_machine.current_state.name == self.name: return true
