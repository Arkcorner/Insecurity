extends CharacterBody2D

var _scale = Vector2(1, 2)
var SPEED = 75
var x = SPEED #value to reset speed back to after sprinting
# dash values
const DASH_SPEED = 50
var dashing = false
var can_dash = true
var dash_count = 2 #values for double jump
const JUMP_VELOCITY = 200.0
var jump_count = 2
var can_jump = true

# Set the Gravity
var gravity = 450


#this is a test for github
func _physics_process(delta):
	if Input.is_action_pressed("pause_menu"):
		get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	if Global.time_running :
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
				velocity.y = 250
			if Input.is_action_pressed("climb_up"):
				velocity.y = -250
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


#func _on_area_2d_body_entered(body):
	#pass # Replace with function body.

#Aydans Atempt
@export_category("Toggle Functions") 
@export_category("Player Properties") # You can tweak these changes according to your likings
@onready var spawn_point = %SpawnPoint


# Tween Animations
func death_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	global_position = spawn_point.global_position
	Global.time_running = false
	await get_tree().create_timer(0.3).timeout
	respawn_tween()
	Global.time_running = true

func respawn_tween():
	var tween = create_tween()
	tween.stop(); tween.play()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15) 

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(_body):
	if _body.is_in_group("Traps"):
		death_tween()
