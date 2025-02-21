extends Area2D

@export var speed: float = Globals.scroll_speed  # How fast the obstacle moves Default 24
@export var despawn_x: float = -30.0  # X position to despawn obstacle
#signal tiles_despawned
signal player_hit

func _ready():
	# Connect the signal for detecting player collision
	body_entered.connect(_on_body_entered)

func _process(delta):
	position.x -= speed * delta
	if position.x < despawn_x:
		queue_free()
		

func _on_body_entered(body):
	if body.name == "player_horse":  # Adjust to match your player node's name
		print("Player hit an obstacle!")
		player_hit.emit()
		# You could emit a signal here or call a player function
		#body.take_damage()
