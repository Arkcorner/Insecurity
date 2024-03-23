extends CharacterBody2D

var _scale = Vector2(1, 2)
var Speed = 75

# dash values
const Dash_speed = 150
var Dashing = false
var Can_dash = true
var Dash_count = 2

#values for double jump
const Jump_velocity = 200.0
var Jump_count = 2
var Can_jump = true

# Set the Gravity
var Gravity = 450

#called for when the scene is instatiated be carefull it gets called every respawn
func _ready():
	self.position = Global.spawn_point
	print("i spawned")

#Main fucntion thats being called every frame pls make stuff outside of it and call that function from here if necessary
func _physics_process(delta):
	print(self.position)
	_movement_handler()
	_pause_menu()
	_handle_game_time()
	move_and_slide()

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

func _pause_menu():
	if Input.is_action_pressed("pause_menu"):
		get_tree().change_scene_to_file("res://UI/main_menu.tscn")

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
		set_scale(_scale)
	if Input.is_action_just_released("crouch"):
		_scale.y = 1
		set_scale(_scale)
	if Input.is_action_just_pressed("dash") and Can_dash:
		Dashing = true
		Dash_count = Dash_count -1 
		$dash_timer.start()
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and Can_jump:
		velocity.y = Jump_velocity * (-1)
		Jump_count = Jump_count-1
	var directiony = Input.get_axis("ui_up","ui_down")
	var directionx = Input.get_axis("ui_left", "ui_right")
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
func _on_dash_timer_timeout() -> void:
	Dashing = false

func _on_area_2d_body_entered(body):
	pass # Replace with function body.
