extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Track the direction the lemming is moving in
var move_direction = 1

@onready var anim = get_node("AnimationPlayer")

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
