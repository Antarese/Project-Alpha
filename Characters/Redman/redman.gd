extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("Redman_Animation_Player")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if velocity.y < 0:
			anim.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	# Flip the animation to the correct direction. 1 = right. -1 = left
	if direction == -1:
		get_node("Redman_Animated_Sprite_2D").flip_h = true
	else:
		get_node("Redman_Animated_Sprite_2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
		#Checking if moving in y axis. Jump or not
		if velocity.y == 0: 
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#Checking if moving in y axis. Jump or not
		if velocity.y == 0:
			anim.play("Idle")
	if velocity.y > 0:
		anim.play("Fall")
	move_and_slide()