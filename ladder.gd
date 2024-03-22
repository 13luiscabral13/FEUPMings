extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	print("Going up ladder")
	var lemming = area.get_parent()
	lemming.go_up_ladder(get_node("."))



func _on_area_2d_area_exited(area):
	print("Area Exited")
	var lemming = area.get_parent()
	lemming.stop_ladder()

