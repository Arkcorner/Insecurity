extends CharacterBody2D

var _scale = Vector2(1, 2)
var Speed = 75
# dash values
const Dash_speed = 50
var Dashing = false
var Can_dash = true
var Dash_count = 2

#values for double jump
const Jump_velocity = 200.0
var Jump_count = 2
var Can_jump = true

var Sprinting = false
# Set the Gravity
var Gravity = 450

#Main fucntion thats being called every frame pls make stuff outside of it and call that function from here if necessary
func _physics_process(delta):
	_movement_handler()
	if Input.is_action_pressed("pause_menu"):
		get_tree().change_scene_to_file("res://UI/main_menu.tscn")
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
				velocity.y += Gravity * delta
			# monitor dash count and stop dashes
		if Global.is_climbing == true:
			if Input.is_action_pressed("sprint"):
				velocity.y = 0
			if Input.is_action_pressed("climb_down"):
				velocity.y = 250
			if Input.is_action_pressed("climb_up"):
				velocity.y = -250
		
		
		if Input.is_action_just_pressed("dash") and Can_dash:
			Dashing = true
			Dash_count = Dash_count-1
			$dash_timer.start()
		
		
	move_and_slide()

func get_direction_from_input():
	var move_dir = Vector2()
	move_dir.x = -Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right")
	move_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	move_dir = move_dir.clamped(1)
	
	return move_dir * Dash_speed

#hanbdle the movement
func _movement_handler():
	#Handle crouch 
	if Input.is_action_pressed("crouch"):
		log( 1.5)
		_scale.y = 0.5
		set_scale(_scale)
	if Input.is_action_just_released("crouch"):
		_scale.y = 1
		set_scale(_scale)
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_up") and Can_jump:
		velocity.y = Jump_velocity * (-1)
		Jump_count = Jump_count-1
	if Input.is_action_pressed("sprint"):
		Sprinting = true
	if Input.is_action_just_released("sprint"):
		Sprinting = false
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		return


#make it stop
func _on_dash_timer_timeout() -> void:
	Dashing = false


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
