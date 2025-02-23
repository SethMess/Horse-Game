extends Node

var default_scroll_speed = 24.0
var scroll_speed = default_scroll_speed  # Or whatever your desired speed is
var acceleration: float = 0.3 # pixels per second per second
var score = 0
var final_score = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	#score_label.color
	pass # Replace with function body.




func _process(delta):
	Globals.scroll_speed += acceleration * delta
	
