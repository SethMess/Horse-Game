extends Node2D

var score: float = 0.0
var score_rate: float = 10.0  # points per second
@onready var score_label = $ScoreLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score += score_rate * delta
	# Optionally update a UI Label with the current score:
	score_label.text = str(int(score))
