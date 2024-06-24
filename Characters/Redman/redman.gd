# First iteration of code
"""
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
"""
#2nd iteration
"""
func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	handle_movement()
	handle_animations()

func apply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_movement():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	sprite.flip_h = (direction == -1)
	move_and_slide()

func handle_animations():
	if velocity.y < 0:
		anim.play("Jump")
	elif velocity.y > 0:
		anim.play("Fall")
	elif velocity.x !=0:
		anim.play("Run")
	else:
		anim.play("Idle")
"""
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -1000.0
const JUMP_STARTUP_VELOCITY = -300.0
const JUMP_APEX_THRESHOLD = 5.0

var last_direction = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Defining the character states
enum State {IDLE, RUNNING, JUMP_STARTUP, JUMP_RISING, JUMP_APEX, JUMP_FALLING, JUMP_LANDING}
var current_state = State.IDLE

#Preload the animation and sprite
@onready var anim = $Redman_Animation_Player
@onready var sprite = $Redman_Animated_Sprite_2D

func _physics_process(delta):
	apply_gravity(delta)
	handle_state()
	handle_movement()
	handle_animations()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_movement():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		last_direction = direction #last_direction is used because the direction will automatically reset when no input is pressed.
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	sprite.flip_h = (last_direction == -1) #if we don't use last_direction, the sprite will be flipped back automatically.
	move_and_slide()

#Handle state commands. What to do at a state when each button is pressed.
func handle_state():
	match current_state:
		State.IDLE: #When the state is idle, jump when spacebar is pressed and run when left or right is pressed
			if Input.is_action_pressed("ui_accept") and is_on_floor():
				transition_to(State.JUMP_STARTUP)
			elif abs(Input.get_axis("ui_left", "ui_right")) > 0:
				transition_to(State.RUNNING)
		State.RUNNING:
			if Input.is_action_pressed("ui_accept") and is_on_floor():
				transition_to(State.JUMP_STARTUP)
			elif abs(Input.get_axis("ui_left", "ui_right")) == 0:
				transition_to(State.IDLE)
		State.JUMP_STARTUP:
			velocity.y = JUMP_STARTUP_VELOCITY
			if velocity.y >= JUMP_VELOCITY:
				transition_to(State.JUMP_RISING)
		State.JUMP_RISING:
			if abs(velocity.y) <= JUMP_APEX_THRESHOLD:
				transition_to(State.JUMP_APEX)
		State.JUMP_APEX:
			if abs(velocity.y) > 0:
				transition_to(State.JUMP_FALLING)
		State.JUMP_FALLING:
			if is_on_floor():
				transition_to(State.JUMP_LANDING)
		State.JUMP_LANDING:
			if anim.has_animation("Jump_Landing") and anim.get_current_animation_position() >= 0.14:
				transition_to(State.IDLE)

#Handle the transitioning between states. What to do when exiting a state and what to do when entering a state
func transition_to(new_state):
	match current_state: #What to do when exiting a state. pass is do nothing
		State.IDLE:
			pass
		State.RUNNING:
			pass
		State.JUMP_STARTUP:
			pass
		State.JUMP_RISING:
			pass
		State.JUMP_APEX:
			pass
		State.JUMP_FALLING:
			pass
		State.JUMP_LANDING:
			pass
	current_state = new_state
	match new_state: #What to do when entering a state. pass is do nothing
		State.IDLE:
			pass
		State.RUNNING:
			pass
		State.JUMP_STARTUP:
			pass
		State.JUMP_RISING:
			pass
		State.JUMP_APEX:
			pass
		State.JUMP_FALLING:
			pass
		State.JUMP_LANDING:
			pass

func handle_animations():
	match current_state:
		State.IDLE:
			anim.play("Idle")
		State.RUNNING:
			anim.play("Run")
		State.JUMP_STARTUP:
			anim.play("Jump_Startup")
		State.JUMP_RISING:
			anim.play("Jump_Rising")
		State.JUMP_APEX:
			anim.play("Jump_Apex")
		State.JUMP_FALLING:
			anim.play("Jump_Falling")
		State.JUMP_LANDING:
			anim.play("Jump_Landing")

