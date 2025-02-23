extends "res://scripts/main_menu.gd"


#@onready var start_button = $StartButton
#const GAME = preload("res://scenes/game.tscn")
# Called when the node enters the scene tree for the first time.

@onready var score_label = $ScoreLabel

func _ready():
	score_label.text = "Score: " + str(int(Globals.final_score))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	Globals.scroll_speed = Globals.default_scroll_speed
	get_tree().change_scene_to_file("res://scenes/game.tscn")
