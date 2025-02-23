extends Node2D

@onready var explosion = $Explosion

# Called when the node enters the scene tree for the first time.
func _ready():
	print("emitting")
	explosion.one_shot = true

func particle_go():
	#explosion.restart()
	
	explosion.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#explosion.one_shot = true
	if Input.is_action_just_pressed("ui_accept"):
		explosion.emitting = true
	#explosion.emitting = false
	#explosion.emitting = true
