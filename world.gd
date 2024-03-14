extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_win():
	var doors = get_tree().get_nodes_in_group("Doors")
	for door in doors:
		var text = door.get_children()[-1]
		print(text.get("theme_override_colors/default_color"))
		if text.get("theme_override_colors/default_color") != Color("yellow"):
			return false
	get_tree().change_scene_to_file("res://winning_menu.tscn")
