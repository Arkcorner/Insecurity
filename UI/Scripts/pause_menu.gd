extends Control

@onready var pause_menu_advice_scene = preload("res://UI/scenes/pause_menu_advice.tscn")
@onready var advice_toggle = true


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if visible == true && advice_toggle == true && Global.advice_array.size() > 1:
		$Advice_Timer.start()
		advice_toggle = false
	global_position = get_parent().get_node("Map/Player/Transition_camera").global_position + Vector2(80,40)
	
	_pause_menu()
	
	#if visible == true && Input.is_action_pressed("pause_menu"):
	#	self.visible = false
	#	get_tree().paused = false

func _on_advice_timer_timeout():
	_advice_scroll()
	advice_toggle = true

#Instantiates Label pause_menu_advice and gives it text based on what's in 
#Global.advice_array.  That should result from opening chests. 

func _advice_scroll():
	var pause_menu_advice_instance = pause_menu_advice_scene.instantiate()
	var advice_array_text_number = (randi_range(1, Global.advice_array.size() - 1))
	var advice_array_text = Global.advice_array[advice_array_text_number]
	pause_menu_advice_instance.text = str(advice_array_text)
	pause_menu_advice_instance.position.y += randi_range(-100,100)
	pause_menu_advice_instance.position.x += 100
	add_child(pause_menu_advice_instance)
	advice_toggle = false


func _on_debug_lvl_pressed(): get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_resume_pressed():
	self.visible = false
	get_tree().paused = false

func _pause_menu():
	if Input.is_action_pressed("pause_menu"):
		get_tree().paused = true
		visible = true
		


