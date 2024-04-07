extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("checkpoint_default")

func _on_body_entered(body):
	
	if body.name == "Player":
		$AnimatedSprite2D.play("checkpoint_reached")
		Global.update_spawn_point(self.global_position)
