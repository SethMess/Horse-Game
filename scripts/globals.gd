extends Node

var scroll_speed = 24.0  # Or whatever your desired speed is
var acceleration: float = 0.3 # pixels per second per second



# Called when the node enters the scene tree for the first time.
func _ready():
	#score_label.color
	pass # Replace with function body.




func _process(delta):
	Globals.scroll_speed += acceleration * delta
