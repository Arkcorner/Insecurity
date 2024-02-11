extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#sets is_climbing to true to simulate climbing
	pass


func _on_body_entered(body):
	if body.name == "Player":
		Global.is_climbing = true
	pass # Replace with function body.


func _on_body_exited(body):
	if body.name == "Player":
		Global.is_climbing = false
	pass # Replace with function body.
