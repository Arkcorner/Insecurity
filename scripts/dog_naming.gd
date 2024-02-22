extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_text_submitted(new_text):
	Global.dog_name = new_text
	Global.time_running = true
	get_node("../../..").visible = false
	pass # Replace with function body.


func _on_gui_input(event):
	Global.time_running = false
	pass # Replace with function body.


func _on_hidden():
	Global.time_running = true
	pass # Replace with function body.
