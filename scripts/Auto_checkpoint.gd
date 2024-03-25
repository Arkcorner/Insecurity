extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	print("something entered")
	if body.name == "Player":
		print("the player entered")
		Global.update_spawn_point(self.global_position)
