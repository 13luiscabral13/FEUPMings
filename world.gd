extends Node2D

var start_time = 0
var level_duration = 200
var all_red = 0
var all_green = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = Time.get_ticks_msec()
	var doors = get_tree().get_nodes_in_group("Doors")
	print(doors)
	for i in doors:
		var door_number = i.get_children()[-1]
		if (door_number.name == "red"):
			all_red += int(door_number.text[-1])
		else:
			all_green += int(door_number.text[-1])
	print("All red: ", all_red, " All green: ", all_green)
	get_node("GreenStatus").text = "0/" + str(all_green)
	get_node("RedStatus").text = "0/" + str(all_red)
	pass # Replace with function body.

func red_lemming_entered():
	var current = int(get_node("RedStatus").text[0])
	var new_current = current + 1
	get_node("RedStatus").text[0] = str(new_current)
func green_lemming_entered():
	var current = int(get_node("GreenStatus").text[0])
	var new_current = current + 1
	get_node("GreenStatus").text[0] = str(new_current)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_time = (Time.get_ticks_msec() - start_time) / 1000
	var current_timer = level_duration - new_time
	get_node("Timer").text = str(current_timer)	
	
	pass

func check_win():
	var doors = get_tree().get_nodes_in_group("Doors")
	for door in doors: 
		var text = door.get_children()[-1]
		print(text.get("theme_override_colors/default_color"))
		if text.get("theme_override_colors/default_color") != Color("yellow"):
			return false
	get_tree().change_scene_to_file("res://winning_menu.tscn")
