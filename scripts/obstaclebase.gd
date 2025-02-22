extends Area2D

@export var speed: float = Globals.scroll_speed  # How fast the obstacle moves Default 24
@export var despawn_x: float = -30.0  # X position to despawn obstacle
#signal tiles_despawned
#signal player_hit
signal player_hit(body)

func _ready():
	# Connect the signal for detecting player collision
	body_entered.connect(_on_body_entered)
	#overlaps_body()

func _process(delta):
	speed = Globals.scroll_speed
	position.x -= speed * delta
	if position.x < despawn_x:
		queue_free()
		

func _on_body_entered(body):
	if body.is_in_group("Player"):  # Adjust to match your player node's name
		#print("Player hit an obstacle!")
		#emit_signal("player_hit", body)
		player_hit.emit(body)
		#emit_signal(player_hit)
		# You could emit a signal here or call a player function
		#body.take_damage()
