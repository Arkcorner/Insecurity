extends CharacterBody2D

var _scale = Vector2(1, 2)
var SPEED = 800
var x = SPEED #value to reset speed back to after sprinting


# dash values
const DASH_SPEED = 2000
var dashing = false
var can_dash = true
var dash_count = 2

#values for double jump
const JUMP_VELOCITY = 1300.0
var jump_count = 2
var can_jump = true

# Set the Gravity
var gravity = 2000

#this is a test for github
func _physics_process(delta):
	if is_on_floor(): 
		dash_count = 2
		jump_count = 2
	if dash_count < 1:
		can_dash = false
	else:
		can_dash = true
	#monitor jump count and stop more jumps in air 
	if jump_count < 1:
		can_jump = false
	else:
		can_jump = true	# Add the gravity.
	if not is_on_floor():
		if Global.is_climbing == false:
			velocity.y += gravity * delta
		# monitor dash count and stop dashes
	if Global.is_climbing == true:
		if Input.is_action_pressed("sprint"):
			velocity.y = 0
		if Input.is_action_pressed("climb_down"):
			velocity.y = 500
		if Input.is_action_pressed("climb_up"):
			velocity.y = -500
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and can_jump:
		velocity.y = JUMP_VELOCITY * (-1)
		jump_count = jump_count-1

	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		dash_count = dash_count-1
		$dash_timer.start()
	#Handle crouch 
	if Input.is_action_pressed("crouch"):
		log( 1.5)
		_scale.y = 0.5
		set_scale(_scale)
	if Input.is_action_just_released("crouch"):
		_scale.y = 1
		set_scale(_scale)
	#Implement the sprint action by increasing and decreasing speed
	if Input.is_action_pressed("sprint"):
		SPEED = 1200
	if Input.is_action_just_released("sprint"):
		SPEED = x
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

#make it stop
func _on_dash_timer_timeout() -> void:
	dashing = false
