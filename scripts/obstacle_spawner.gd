extends Node2D

@onready var obstacles_container = $Obstacles

# Preload obstacle scenes
var RockObstacleScene = preload("res://scenes/rock_obstacle.tscn")
var TreeObstacleScene = preload("res://scenes/tree_obstacle.tscn")
var RiverObstacleScene = preload("res://scenes/river_obstacle.tscn")
const HorseCollectableScene = preload("res://scenes/horse_collectable.tscn")
@onready var herd = $"../Herd"
#signal player_signal = $"player_signal"

#var last_ob_was_river = false

# Number of vertical tiles to pick from
const TILE_COUNT_Y = 10
const TILE_SIZE = 8
const BACKGROUND_OFFSET = 3  # Vertical offset for the playable area

var background_offset_x = 0.0
var last_spawn_x = 0.0
var BACKGROUND_SPEED: float = Globals.scroll_speed  # pixels per second (adjust to your parallax speed)
var tiles_since_last_river = 0  # Start high so we don't get a river right away
const MIN_TILES_BETWEEN_RIVERS = 1  # Adjust to prevent back-to-back rivers
#var obsticle_spacing = 1
#var obsticle_cooldown = 0
var tile_skip_counter = 0
const SKIP_TILES = 1  # Skip every 1 tile, or set to 2 or 3 to slow it down further



func _process(delta):
	BACKGROUND_SPEED = Globals.scroll_speed
	background_offset_x += BACKGROUND_SPEED * delta

	# Check if we've moved a full tile
	if background_offset_x - last_spawn_x >= TILE_SIZE:
		last_spawn_x += TILE_SIZE
		tile_skip_counter += 1
		if tile_skip_counter > SKIP_TILES:
			tile_skip_counter = 0
			spawn_obstacles_or_river()


func spawn_obstacles_or_river():
	if tiles_since_last_river < MIN_TILES_BETWEEN_RIVERS:
		spawn_rock_or_tree_obstacle()
		tiles_since_last_river += 1
	else:
		var spawn_river = randi_range(0, 10)
		if spawn_river < 3:  # 30% chance for river
			spawn_river_obstacle()
			tiles_since_last_river = 0
			tile_skip_counter -= 3
		else:
			spawn_rock_or_tree_obstacle()
			tiles_since_last_river += 1


func spawn_rock_or_tree_obstacle():
	var num_obstacles = randi_range(1, 2)  # Reduce max to 2 to prevent clutter
	var used_tiles = []

	for i in range(num_obstacles):
		var tile_y
		# Avoid spawning multiple obstacles in the same vertical position
		while true:
			tile_y = randi() % TILE_COUNT_Y
			if not tile_y in used_tiles:
				used_tiles.append(tile_y)
				break

		var obstacle
		
		if randf() < 0.5:
			obstacle = RockObstacleScene.instantiate()
		else:
			obstacle = TreeObstacleScene.instantiate()
		
		connect_signal(obstacle)

		obstacle.position.y = (tile_y + BACKGROUND_OFFSET) * TILE_SIZE

		var camera_x = get_viewport().get_camera_2d().position.x
		var offscreen_x = camera_x * 2 + TILE_SIZE
		offscreen_x = snapped(offscreen_x, TILE_SIZE)

		obstacle.position.x = offscreen_x
		obstacles_container.add_child(obstacle)
	
	spawn_horse(used_tiles)
	


func spawn_river_obstacle():
	var river = RiverObstacleScene.instantiate()

	connect_signal(river)
	# Align Y to the background offset
	river.position.y = BACKGROUND_OFFSET * TILE_SIZE

	# Align X position to grid, just offscreen to the right
	var camera_x = get_viewport().get_camera_2d().position.x
	var offscreen_x = camera_x * 2 + TILE_SIZE  # Just off the right side
	offscreen_x = snapped(offscreen_x, TILE_SIZE)  # Snap X position to TILE_SIZE grid

	#print("off screen x: " + str(offscreen_x))
	river.position.x = offscreen_x

	obstacles_container.add_child(river)

func spawn_horse(used_tiles):
	if randf() < 0.2:
		var tile_y
		while true:
			tile_y = randi() % TILE_COUNT_Y
			if not tile_y in used_tiles:
				used_tiles.append(tile_y)
				break
		var horse = HorseCollectableScene.instantiate()
		
		connect_horse(horse)
		
		horse.position.y = (tile_y + BACKGROUND_OFFSET) * TILE_SIZE

		# Align X position to grid, just offscreen to the right
		var camera_x = get_viewport().get_camera_2d().position.x
		var offscreen_x = camera_x * 2 + TILE_SIZE  # Just off the right side
		offscreen_x = snapped(offscreen_x, TILE_SIZE)  # Snap X position to TILE_SIZE grid

		#print("off screen x: " + str(offscreen_x))
		horse.position.x = offscreen_x

		obstacles_container.add_child(horse)

func connect_horse(horse):
	var callable_target = Callable(herd, "_horse_collected")
	horse.connect("collected", callable_target)
	print("horse connected")

func connect_signal(obstacle):
	#print("Attempting to connect signal on obstacle")
	# Verify that herd is not null.
	if herd == null:
		push_error("Herd node is null!")
		return

	# Create a callable for the method on the herd node.
	var callable_target = Callable(herd, "_on_obstacle_body_entered")
	if not callable_target.is_valid():
		push_error("Callable is not valid! Check that _on_obstacle_body_entered exists on herd.")
		return

	obstacle.connect("player_hit", callable_target)
	#callable_target = Callable(self, "_on_obstacle_player_hit")
	#obstacle.connect("player_hit", callable_target)
	#print("Signal connected successfully.")


#func _on_timer_timeout():
	##spawn_obstacles_or_river()
	#pass


#func _on_obstacle_player_hit(body):
	#print("obsticle hit")
	## EMIT SIGNAL
	#pass # Replace with function body.
