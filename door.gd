extends Node2D


func open():
	$AnimationPlayer.play("open")
	
func _ready():
	add_to_group("Doors")

func verify_open(node):
	var node_text = node.text
	var i = int(node_text[0])
	var j = int(node_text[-1])
	if (i != j):
		i+=1
		node.text[0] = str(i)
		if (i==j):
			node.set("theme_override_colors/default_color", Color("yellow"))
		return true
	else:
		return false
	


func _on_area_2d_area_entered(area):
	var openability = false
	var parent = area.get_parent()
	if "Red" in parent.name:
		var red = get_node("red")
		if red:
			openability = verify_open(red)
	elif "Green" in parent.name:
		var green = get_node("green")
		if green:
			openability = verify_open(green)
			
	if openability:
		open()
		area.get_parent().stop_moving() 
		area.get_parent().queue_free()



func _on_animation_player_animation_finished(anim_name):
	var text = get_children()[-1]
	if (text.get("theme_override_colors/default_color") == Color("yellow")):
		get_parent().check_win()
