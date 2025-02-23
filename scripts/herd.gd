extends Node2D

# Herd.gd
var followers := []
@onready var player_horse = $player_horse
const PLAYER_HIT = preload("res://scenes/player_hit.tscn")
const EXPLOSION = preload("res://scenes/explosion.tscn")
func _ready():
	pass
	#player_hit.connect(_on_player_horse_player_hit)
	#_on_player_horse_player_hit.connect(player_hit)
# Call this when the player collects a new horse.
func add_follower(pos, index):
	var follower = preload("res://scenes/follower_horse.tscn").instantiate()
	
	# Determine the target: if there's no follower yet, follow the player.
	# Otherwise, follow the last follower in the array.
	if followers.is_empty():
		#print("player" + str(player_horse))
		follower.target = player_horse
		# Optionally, set an offset for the first follower
		follower.position_offset = Vector2(-10, 0)
	else:
		follower.target = followers[followers.size() - 1]
		# Offset subsequent followers slightly for a natural formation.
		follower.position_offset = Vector2(-10, 0)# + Vector2(0, 5 * followers.size())
	follower.set_position(pos)
	follower.set_color(index)
	#follower.position
	followers.append(follower)
	#call_deferred(add_child(follower))
	call_deferred("add_child", follower)


func _on_timer_timeout():
	pass
	#if followers.size() < 5:
		#add_follower()
	#print("added follower")
	#pass # Replace with function body.
	
func _horse_collected(pos, index):
	#print("adding follower")
	if followers.size() < 10:
		#print(pos)
		add_follower(pos, index)


func _on_player_horse_player_jumped():
	for i in range(followers.size()):
		var delay = (i + 1) * 0.20  # Delay increases for each follower
		var timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = delay
		# Create a callable bound with the specific follower
		var jump_callable = Callable(self, "_on_follower_jump_timeout").bind(followers[i])
		timer.connect("timeout", jump_callable)
		add_child(timer)
		timer.start()

func _on_follower_jump_timeout(follower):
	if follower != null:
		follower.jump()


func remove_follower():
	if followers.size() > 0:
		var removed = followers.pop_back()
		var pos = removed.position
		removed.queue_free()
		_on_obstacle_player_hit(pos)
		player_horse.flash_red(false)
	else:
		# No followers remain, so trigger game over:
		_on_obstacle_player_hit(player_horse.position)
		#print("GAME OVER")
		# Trigger flash effect
		player_horse.flash_red(true)
		
		# Create a one-shot timer for a delay (e.g., 1 second)
		var delay_timer = Timer.new()
		delay_timer.one_shot = true
		delay_timer.wait_time = 1.0  # 1 second delay
		add_child(delay_timer)
		delay_timer.start()
		await delay_timer.timeout
		_on_game_over()
	

func _on_game_over():
	# Optionally remove/hide the player
	#player_horse.call_deferred("queue_free")
	#call_deferred("queue_free", player_horse)
	# Assume you store the player's score in a global variable, for example Globals.score,
	# or you could have a dedicated ScoreManager.
	Globals.final_score = Globals.score  # Save the final score to show on the Game Over screen.
	
	# Change to the Game Over scene.
	# One common method is to call change_scene with the path:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/game_over.tscn")
	#get_tree().change_scene()


func _on_obstacle_player_hit(pos):
	var particles = EXPLOSION.instantiate()
	add_child(particles)
	particles.position = pos
	
	particles.emitting = true

func _on_obstacle_body_entered(body):
	# Check if the colliding body is the player
	# (assuming the player's collision shape has been added to a group "Player")
	#if body.is_in_group("Player"):
	#print("in Herd: " + str(body))
	remove_follower()
