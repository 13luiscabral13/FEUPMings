extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_abilities_button_pressed():
	get_tree().change_scene_to_file("res://abilities_menu.tscn")


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_obstacles_button_pressed():
	get_tree().change_scene_to_file("res://obstacles_menu.tscn")
