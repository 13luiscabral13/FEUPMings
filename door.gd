extends Node2D


func open():
	$AnimationPlayer.play("open")


func _on_area_2d_area_entered(area):
	print("Lemming entered")
	if area.get_parent() is Lemming:
		open()
		area.get_parent().stop_moving() # Replace with function body.
