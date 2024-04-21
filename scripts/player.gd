extends CharacterBody2D

var _scale = Vector2(1, 2)
var Speed = 75
var crouch = false
var notCrouching = true

# dash values
const Dash_speed = 150
var Dashing = false
var Can_dash = true
var Dash_count = 2
#values for double jump
const Jump_velocity = 165.0
var Jump_count = 2
var jumping = false
var Can_jump = true
# Set the Gravity
var Gravity = 450
var chrouching = false

@onready var state_machine_tree = $AnimationTree
# Wind
@export var wind_light = false
@export var wind_medium = false
@export var wind_strong = false

#called for when the scene is instatiated be carefull it gets called every respawn
func _ready():
	self.position = Global.spawn_point
	print("i spawned")
	

#Main fucntion thats being called every frame pls make stuff outside of it and call that function from here if necessary
func _physics_process(delta):
	_movement_handler()
	_handle_game_time()
	move_and_slide()
	_wall_slide()
	_wind()

func _process(delta):
	state_machine_tree.set("parameters/conditions/jumping", _check_if_jumping())
	state_machine_tree.set("parameters/conditions/crouching", _check_if_crouching())
	state_machine_tree.set("parameters/conditions/notCrouching", notCrouching)
	
func _handle_climbing():
	if Global.is_climbing == true:
		Gravity = 0
		if Input.is_action_pressed("ui_down"):
			velocity.y = 50
		if Input.is_action_pressed("ui_up"):
			velocity.y = -50
		if Input.is_action_just_released("ui_down"):
			velocity.y = 0
		if Input.is_action_just_released("ui_up"):
			velocity.y = 0
	if Global.is_climbing == false:
		Gravity = 450

func _handle_game_time():
	if Global.time_running :
		if is_on_floor(): 
			Dash_count = 2
			Jump_count = 2
		if Dash_count < 1:
			Can_dash = false
		else:
			Can_dash = true
		#monitor jump count and stop more jumps in air 
		if Jump_count < 1:
			Can_jump = false
		else:
			Can_jump = true	# Add the gravity.
		if not is_on_floor():
			if Global.is_climbing == false:
				velocity.y += Gravity * 0.0167

func _movement_handler():
	#Handle crouch 
	if Input.is_action_pressed("crouch"):
		log( 1.5)
		_scale.y = 0.5
		$CollisionShape2D.set_scale(_scale)
		Speed = 25
		Can_jump = false
		crouch = true
		notCrouching = false
	if Input.is_action_just_released("crouch"):
		_scale.y = 1
		$CollisionShape2D.set_scale(_scale)
		Speed = 75
		Can_jump = true
		crouch = false
		notCrouching = true
	if Input.is_action_just_pressed("dash") and Can_dash:
		Dashing = true
		Dash_count = Dash_count -1 
		$dash_timer.start()
	if Input.is_action_pressed("sprint"):
		Speed = 100
	if Input.is_action_just_released("sprint"):
		Speed = 75
		
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and Can_jump:
		velocity.y = Jump_velocity * (-1)
		Jump_count = Jump_count-1
		jumping = true
		
	var directiony = Input.get_axis("ui_up","ui_down")
	var directionx = Input.get_axis("ui_left", "ui_right")
	if Input.is_action_just_pressed("ui_left"):
		$AnimatedSprite2D.set_flip_h(true)
	if Input.is_action_just_pressed("ui_right"):
		$AnimatedSprite2D.set_flip_h(false)
	if directionx:
		if Dashing:
			velocity.x = directionx * Dash_speed
			velocity.y = directiony * Dash_speed
		else:
			velocity.x = directionx * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		return

#stop timer and set dashing to false
func _on_dash_timer_timeout() -> void: Dashing = false

func _on_area_2d_body_entered(body):
	pass # Replace with function body.

func _wall_slide():

	if is_on_wall_only() && velocity.y > 0:
		Gravity = 100
	else:
		Gravity = 450

func _wind():
	if wind_light == true:
		position.x -= .5
	elif wind_medium == true:
		position.x -= .75
	elif wind_strong == true:
		position.x -= 1	

func _check_if_jumping():
	return velocity.y < 0 

func _on_jump_timer_timeout(): jumping = false

func _check_if_crouching():
	return crouch
