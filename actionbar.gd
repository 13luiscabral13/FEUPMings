extends Node2D

@onready var grid = get_node("GridContainer")

var pressed_texture = preload("res://assets/others/gray-frame.png")
var selected_button = null

# Called when the node enters the scene tree for the first time.
func _ready():
	#Connect the button toggled signal
	for button in grid.get_children():
		if button is TextureButton:
			print("Button ", button, " connected")
			button.connect("pressed", _on_button_toggled.bind(button))

func _on_button_toggled(button):
	# Unselect previous button if selecting a new one
	if button.button_pressed && selected_button != null:
		selected_button.button_pressed = false
		
	# Select the new button
	if button.button_pressed:
		selected_button = button
		print("Button pressed: ", button)
	else:
		selected_button = null
