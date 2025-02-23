extends Node2D

var score: float = 0.0
var score_rate: float = 10.0  # points per second
var shift_threshold = 50.0   # change effect every 50 points
var last_shift_score = 0.0
var shader_level = 0
@onready var score_label = $ScoreLabel

#const SCREEN_COLOR_SHIFT = preload("res://scenes/screen_color_shift.tscn")
#@onready var screen_color_shift = $ScreenColorShift


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score += score_rate * delta
	score_label.text = str(int(score))
	Globals.score = score
	
	# Check if we've passed the threshold for a hue shift.
	#if score - last_shift_score >= shift_threshold:
		#last_shift_score = score
		#shader_level = min(shader_level + 1, 10)
		## Calculate the new blend value (for example, from 1.0 to 0.0)
		#var target_blend = 1.0 - (shader_level * 0.1)
		# Tween the blend parameter over 1 second for a smooth transition:
		#var tween = create_tween()
		#tween.tween_property(screen_color_shift.material, "shader_param/blend", target_blend, 1.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
