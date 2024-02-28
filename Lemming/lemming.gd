extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Track the direction the lemming is moving in
var move_direction = 1

@onready var anim = get_node("AnimationPlayer")

func _on_ready():
	anim.connect("animation_finished", playNextAnim)
	anim.play("Run")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_wall():
		#print("Hit wall")
		move_direction *= -1
		#var collider = get_slide_collision(0).get_collider()
	
	if move_direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	else:
		get_node("AnimatedSprite2D").flip_h = false
		
	# Automatically move in the current direction
	velocity.x = move_direction * SPEED
	move_and_slide()

func playNextAnim(anim_name):
	print("Playing next animation")
	
	if anim_name == "Jump":
		print("Changing animation to run")
		anim.play("Run")

func apply_action_if_button_pressed():
	var button = check_action_button_pressed()
	print("Button: ", button.name)
	
	if button != null:
		apply_action(button.name)

func check_action_button_pressed():
	# Retrieve all nodes belonging to the group "action_buttons"
	var buttons = get_tree().get_nodes_in_group("action_buttons")
	
	# Iterate through the nodes in the group
	for button in buttons:
		# Check if the button is pressed
		if button.button_pressed:
			return button  # Return the pressed button
		
	# If no button is pressed, return null
	return null
	
func apply_action(action):
	if action == "Button Jumping":
		print("Jump")
		anim.play("Jump")
		velocity.y = JUMP_VELOCITY
	elif action == "Button Blocking":
		print("Block")
	elif action == "Button Playing Guitar":
		print("Play Guitar")
	elif action == "Button Laying":
		print("Lay")
	elif action == "Button Scared":
		print("Scared")

func _on_input_event_red_lemming(viewport, event, shape_idx):
	# Check for left clicks for the mouse on characters
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var character = get_node(".")
		print("Character pressed: ", character)
		
		apply_action_if_button_pressed()
		
func _on_input_event_green_lemming(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Check for left clicks for the mouse on characters
		var character = get_node(".")
		print("Character pressed: ", character)
		
		apply_action_if_button_pressed()
