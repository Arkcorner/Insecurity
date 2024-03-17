extends Node2D

@onready var caught = false
@onready var player = get_tree().get_root().get_node("World").get_node("Player")
@onready var strawberry_clear = $Strawberry_Clear
@onready var strawberry_item = $Strawberry_Item


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if caught == true:
		strawberry_item.global_position = player.global_position + Vector2(-100, -100)


func _on_strawberry_item_body_entered(body):
	caught = true


func _on_strawberry_clear_body_entered(body):
	if caught == true:
		caught = false
		Global.strawberry_count += 1
		print(Global.strawberry_count)
		strawberry_item.queue_free()
