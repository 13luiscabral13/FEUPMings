extends CharacterBody2D
class_name Lemming

const SPEED = 70.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



#Track the direction the lemming is moving in
var move_direction = 1

@onready var anim = get_node("AnimationPlayer")

func _on_ready():
	add_to_group("lemmings")
	anim.connect("animation_finished", playNextAnim)
	anim.play("Run")

func _physics_process(delta):
	# Add the gravity.
	if (not is_on_floor()) and (anim.get_current_animation() != "Climb"):
		velocity.y += gravity * delta
	
	if is_on_wall():
		move_direction *= -1
		#var collider = get_slide_collision(0).get_collider()
	
	if move_direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif move_direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
		
	if (anim.get_current_animation() == "Climb"):
		velocity.x = 0
		velocity.y = -40
	elif (anim.get_current_animation() == "Jump"):
		velocity.x = move_direction * SPEED * 1.5
	else:
		velocity.x = move_direction * SPEED
	move_and_slide()

func _on_area_2d_input_event(viewport, event, shape_idx):
		# Check for left clicks for the mouse on characters
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var character = get_node(".")
		print("Character pressed: ", character)
		
		if (able_to_move(character)):
			apply_action_if_button_pressed()

func able_to_move(lemming):
	var animationPlayer = lemming.get_node("AnimationPlayer")
	var current = animationPlayer.get_current_animation()
	if (current == "Drinking" || current == "Texting" || current == "Block" || current == "Lay"):
		return false
	return true

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
	var layingCollisionShape = $LayingCollisionShape
	
	standingCollisionShape.disabled = true
	layingCollisionShape.disabled = true
	
	if collision == "standing":
		standingCollisionShape.disabled = false
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
		collision_layer = 1
		collision_mask = 3 # 3 in binary, which means that layers 1 and 2 are active
	elif action == "Button Playing Guitar":
		print("Play Guitar")
		anim.play("Play Guitar")
		move_direction = 0
		attract_lemmings()
		
		# TO-DO
		# After 5 secs the lemming starts running again
		
	elif action == "Button Laying":
		print("Lay")
		anim.play("Lay")
		collision_layer = 1
		collision_mask = 3 # 3 in binary, which means that layers 1 and 2 are active
	elif action == "Button Scared":
		print("Scared")
		anim.play("Scared")
		move_direction = 0
		
func attract_lemmings():
	print("Attracting lemmings")
	var lemmings = get_tree().get_nodes_in_group("lemmings")
	
	for lemming in lemmings:
		if get_node(".") == lemming || !able_to_move(lemming):
			# Skip because it's the lemming itself or the lemming can't move
			continue
		# Calculate the direction towards the target lemming for each lemming
		var direction = (global_position - lemming.global_position).normalized()[0]
		if direction < 0:
			lemming.move_direction = -1
		elif direction > 0:
			lemming.move_direction = 1
	
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
	collision_layer = 1
	collision_mask = 3 # 3 in binary, which means that layers 1 and 2 are active
	#activate_collision("standing")

func go_up_ladder():
	anim.play("Climb")

func stop_ladder():
	print("Exit ladder")
	velocity.y = 0
	move_direction *=-1
	velocity.x += SPEED * move_direction
	anim.play("Run")
