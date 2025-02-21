extends Node2D

# Herd.gd
var followers := []
@onready var player_horse = $player_horse

func _ready():
	pass
	#player_hit.connect(_on_player_horse_player_hit)
	#_on_player_horse_player_hit.connect(player_hit)
# Call this when the player collects a new horse.
func add_follower():
	var follower = preload("res://scenes/follower_horse.tscn").instantiate()
	
	# Determine the target: if there's no follower yet, follow the player.
	# Otherwise, follow the last follower in the array.
	if followers.is_empty():
		print("player" + str(player_horse))
		follower.target = player_horse
		# Optionally, set an offset for the first follower
		follower.position_offset = Vector2(-10, 0)
	else:
		follower.target = followers[followers.size() - 1]
		# Offset subsequent followers slightly for a natural formation.
		follower.position_offset = Vector2(-10, 0)# + Vector2(0, 5 * followers.size())
	
	followers.append(follower)
	add_child(follower)


func _on_timer_timeout():
	if followers.size() < 5:
		add_follower()
	#print("added follower")
	#pass # Replace with function body.


func _on_player_horse_player_jumped():
	for i in range(followers.size()):
		var delay = (i + 1) * 0.25  # Delay increases for each follower
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = delay
		# Create a callable bound with the specific follower
		var jump_callable = Callable(self, "_on_follower_jump_timeout").bind(followers[i])
		timer.connect("timeout", jump_callable)
		add_child(timer)
		timer.start()

func _on_follower_jump_timeout(follower):
	follower.jump()
	
func remove_follower():
	if followers.size() > 0:
		var removed = followers.pop_back()
		removed.queue_free()


func _on_player_horse_player_hit():
	print("removing follower")
	remove_follower()
