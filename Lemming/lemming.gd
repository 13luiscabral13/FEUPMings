extends CharacterBody2D
class_name Lemming

const SPEED = 50.0
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
		print("Hit wall: ", get_node("."))
		move_direction *= -1
		#var collider = get_slide_collision(0).get_collider()
	
	if move_direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif move_direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
		
	# Automatically move in the current direction
	velocity.x = move_direction * SPEED
	move_and_slide()
	
func _on_input_event(viewport, event, shape_idx):
	# Check for left clicks for the mouse on characters
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var character = get_node(".")
		print("Character pressed: ", character)
		
		apply_action_if_button_pressed()

func playNextAnim(anim_name):
	if anim_name == "Jump":
		anim.play("Run")
	elif anim_name == "Scared":
		# Change the animation direction
		if get_node("AnimatedSprite2D").flip_h == true:
			move_direction = 1
		elif get_node("AnimatedSprite2D").flip_h == false:
			move_direction = -1
		
		anim.play("Run")
	elif anim_name == "Lay":
		move_direction = 0
		# Activate laying collision shape
		activate_collision("laying")
		
func activate_collision(collision):
	var standingCollisionShape = $StandingCollisionShape
	var runningCollisionShape = $RunningCollisionShape
	var layingCollisionShape = $LayingCollisionShape
	
	standingCollisionShape.disabled = true
	runningCollisionShape.disabled = true
	layingCollisionShape.disabled = true
	
	if collision == "standing":
		standingCollisionShape.disabled = false
	elif collision == "running":
		runningCollisionShape.disabled = false
	elif collision == "laying":
		layingCollisionShape.disabled = false

func apply_action_if_button_pressed():
	var button = check_action_button_pressed()
	
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
		anim.play("Block")
		move_direction = 0
		var character = get_node(".")
		character.collision_layer = 1
		character.collision_mask = 3 # 7 in binary, which means that layers 1, 2 and 3 are active
		#activate_collision("standing")
	elif action == "Button Playing Guitar":
		print("Play Guitar")
		anim.play("Play Guitar")
		move_direction = 0
		#activate_collision("standing")
	elif action == "Button Laying":
		print("Lay")
		anim.play("Lay")
	elif action == "Button Scared":
		print("Scared")
		anim.play("Scared")
		move_direction = 0
		
		
func stop_moving():
	anim.play("Idle")
	move_direction = 0
	#activate_collision("standing")
	
func drinking():
	anim.play("Drinking")
	move_direction = 0
	#activate_collision("standing")

func texting():
	anim.play("Texting")
	move_direction = 0
	#activate_collision("standing")

