# Global values

extends Node

var spawn_point = Vector2(-205,-77)
var advice_array = [0]
var double_jump_charged = false
var dash_is_charged = false
var time_running = true
var is_climbing = false
var dog_name = "Dexter"
var plank_count = 0 
var strawberry_count = 0

func update_spawn_point(new_position):
	spawn_point = new_position
