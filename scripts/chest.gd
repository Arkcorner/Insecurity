extends Area2D

@onready var animation = $AnimatedSprite2D
@onready var can_interact = false
@onready var open = false
@onready var has_been_opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label_Chest_Open.hide()
	$Label_Insecurity_Advice.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if open == false:
		animation.play("closed")
	elif open == true:
		animation.play("open")
	if can_interact == true:
		if Input.is_action_just_pressed("interact") && open == false:
			open = true
			if has_been_opened == false:
				has_been_opened = true
				$Label_Chest_Open.visible = false
				$Label_Insecurity_Advice.visible = true
				Global.advice_array.append($Label_Insecurity_Advice.text)
				
		elif Input.is_action_just_pressed("interact") && open == true:
			open = false


func _on_body_entered(body):
	print(body)
	if has_been_opened == false:
		$Label_Chest_Open.visible = true
	elif has_been_opened == true:
		$Label_Insecurity_Advice.visible = true
	
	can_interact = true
		


func _on_body_exited(body):
	if has_been_opened == false:
		$Label_Chest_Open.visible = false
	elif has_been_opened == true:
		$Label_Insecurity_Advice.visible = false
	can_interact = false
