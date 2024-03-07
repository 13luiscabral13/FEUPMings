extends Node2D


func open():
	$AnimationPlayer.play("open")

func verify_open(node):
	var node_text = node.text
	var i = int(node_text[0])
	var j = int(node_text[-1])
	if (i != j):
		i+=1
		node.text[0] = str(i)
		return true
	else:
		return false
	


func _on_area_2d_area_entered(area):
	var can_open = false
	var parent = area.get_parent()
	if "Red" in parent.name:
		var red = get_node("red")
		if red:
			can_open = verify_open(red)
	elif "Green" in parent.name:
		var green = get_node("green")
		if green:
			can_open = verify_open(green)
			
	if can_open:
		open()
		area.get_parent().stop_moving() # Replace with function body.
		
		
