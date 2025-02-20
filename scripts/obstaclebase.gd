extends Area2D

@export var speed: float = -30.0  # How fast the obstacle moves
@export var despawn_x: float = -10.0  # X position to despawn obstacle

func _ready():
	# Connect the signal for detecting player collision
	body_entered.connect(_on_body_entered)

func _process(delta):
	position.x -= speed * delta
	if position.x < despawn_x:
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":  # Adjust to match your player node's name
		print("Player hit an obstacle!")
		# You could emit a signal here or call a player function
		#body.take_damage()
