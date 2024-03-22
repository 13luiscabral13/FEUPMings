extends Node2D

var start_time = 0
var level_duration = 200
var needed_red = 0
var needed_green = 0
var all_lemmings = [0, 0]
var dead_lemmings = [0, 0]

# Called when the node enters the scene tree for the first time.
func _ready():
	start_time = Time.get_ticks_msec()
	var doors = get_tree().get_nodes_in_group("Doors")
	print(doors)
	for i in doors:
		var door_number = i.get_children()[-1]
		if (door_number.name == "red"):
			needed_red += int(door_number.text[-1])
		else:
			needed_green += int(door_number.text[-1])
	var lemmings = get_tree().get_nodes_in_group("lemmings")
	for i in lemmings:
		if "Red" in i.name:
			all_lemmings[0] += 1
		else:
			all_lemmings[1] += 1
	get_node("GreenStatus").text = "0/" + str(needed_green)
	get_node("RedStatus").text = "0/" + str(needed_red)
	pass # Replace with function body.

func red_lemming_entered():
	var current = int(get_node("RedStatus").text[0])
	var new_current = current + 1
	get_node("RedStatus").text[0] = str(new_current)
func green_lemming_entered():
	var current = int(get_node("GreenStatus").text[0])
	var new_current = current + 1
	get_node("GreenStatus").text[0] = str(new_current)

func add_dead_lemming(color):	
	dead_lemmings[color] += 1
	print("Dead: ", dead_lemmings)
	print("All: ", all_lemmings)
	var alive_lemmings = [all_lemmings[0]-dead_lemmings[0], all_lemmings[1]-dead_lemmings[1]]	
	if (needed_red > alive_lemmings[0] or needed_green > alive_lemmings[1]):
		get_tree().change_scene_to_file("res://losing_menu.tscn")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://main.tscn")
	var new_time = (Time.get_ticks_msec() - start_time) / 1000
	var current_timer = level_duration - new_time
	if (current_timer == -1):
		get_tree().change_scene_to_file("res://losing_menu.tscn")
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
