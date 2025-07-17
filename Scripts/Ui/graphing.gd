extends CanvasLayer
class_name data_graph

@onready var graph_line: Line2D = %GraphLine
@onready var y_lables: Control = %YLabels
@onready var data_types: HBoxContainer = %DataTypes

var current_data : Array
var reserved_data : Dictionary

func _ready() -> void: clear_data()

func clear_data():
	current_data.clear()
	reserved_data = {
		"HP": [],
		"SPEED": [],
		"POP": [],
		"VISION": [],
		"ACTION": [],
		"DRIVE": [],
		"GESTATION": [],
		"ATTRACTIVENESS": [],
	}

func toggle_graph(): 
	%Graph.visible = !%Graph.visible
	print(Global.population_count)

func update_data() -> void: show_data(current_data)

func select_data(type : String):
	await get_tree().create_timer(0.01).timeout
	if reserved_data.has(type): current_data = reserved_data[type]; show_data(current_data)
	#match type:
		#"HP" : %Health.get_node("Button").button_pressed = true
		#"SPEED" : %Speed.get_node("Button").button_pressed = true

func data_button_press(type : String):
	for node in data_types.get_children():
		node.get_node("Button").button_pressed = false

func show_data(data : Array):
	if data.size() <= 1: return
	
	#Remove all data points from graph line
	graph_line.clear_points()
	
	var highest_y_data : float = 0.0
	var highest_x_data : float = 0.0
	
	var lowest_y_data : float = 0.0
	var lowest_x_data : float = 0.0
	
	#Find max values for plotting
	for data_dict in data:
		if data_dict["X"] > highest_x_data: highest_x_data = data_dict["X"]
		if data_dict["Y"] > highest_y_data: highest_y_data = data_dict["Y"]
		if data_dict["X"] < lowest_x_data: lowest_x_data = data_dict["X"]
		if data_dict["Y"] < lowest_y_data: lowest_y_data = data_dict["Y"]
	
	#Create lines on graph
	for point in data:
		if point.has("X") and point.has("Y"):
			var x = (point["X"] - lowest_x_data / highest_x_data) * 793.0
			var y = (point["Y"] - lowest_y_data / highest_y_data) * 535.0  # Flip sign if needed for proper direction
			graph_line.add_point(Vector2(x, -y))
	
	#Create Labels
	%LabelOne.text = str(0.0)
	%LabelOne2.text = str(highest_y_data)
	%LabelOne3.text = str(highest_y_data / 2)
	%LabelOne4.text = str(highest_y_data / 4)
	%LabelOne5.text = str(highest_y_data * 0.75)
