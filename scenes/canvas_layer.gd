extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var pause_pressed = Input.action_press("ui_cancel")
	#if pause_pressed:
		#get_tree().paused = true
	pass

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print("pressed")
		get_tree().paused = not get_tree().paused
		#visible = get_tree().paused
