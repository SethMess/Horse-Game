extends Node2D

@onready var obstacles_container = $Obstacles

# Preload obstacle scenes
var RockObstacleScene = preload("res://scenes/rock_obstacle.tscn")
var TreeObstacleScene = preload("res://scenes/tree_obstacle.tscn")
var RiverObstacleScene = preload("res://scenes/river_obstacle.tscn")

var last_ob_was_river = false

# Number of vertical tiles to pick from
const TILE_COUNT_Y = 10
const TILE_SIZE = 8
const BACKGROUND_OFFSET = 3  # Vertical offset for the playable area


func spawn_obstacles_or_river():
	var spawn_river = randi_range(0, 10)  # 30% chance for river, 70% for rocks/trees
	
	if spawn_river < 3 and !last_ob_was_river:
		print("river")
		spawn_river_obstacle()
		last_ob_was_river = true
	else:
		print("obsticle")
		var num_obstacles = randi_range(1, 3)  # Spawn 1 to 3 rocks/trees
		for i in range(num_obstacles):
			spawn_rock_or_tree_obstacle()
		last_ob_was_river = false


func spawn_rock_or_tree_obstacle():
	var obstacle
	if randf() < 0.5:
		obstacle = RockObstacleScene.instantiate()
	else:
		obstacle = TreeObstacleScene.instantiate()

	# Pick a random Y position based on tiles
	var tile_y = randi() % TILE_COUNT_Y
	obstacle.position.y = (tile_y + BACKGROUND_OFFSET) * TILE_SIZE

	# Align X position to grid, just offscreen to the right
	var camera_x = get_viewport().get_camera_2d().position.x
	var offscreen_x = camera_x * 2 + TILE_SIZE  # Just off the right side
	offscreen_x = snapped(offscreen_x, TILE_SIZE)  # Snap X position to TILE_SIZE grid

	obstacle.position.x = offscreen_x

	obstacles_container.add_child(obstacle)


func spawn_river_obstacle():
	var river = RiverObstacleScene.instantiate()

	# Align Y to the background offset
	river.position.y = BACKGROUND_OFFSET * TILE_SIZE

	# Align X position to grid, just offscreen to the right
	var camera_x = get_viewport().get_camera_2d().position.x
	var offscreen_x = camera_x * 2 + TILE_SIZE  # Just off the right side
	offscreen_x = snapped(offscreen_x, TILE_SIZE)  # Snap X position to TILE_SIZE grid

	print("off screen x: " + str(offscreen_x))
	river.position.x = offscreen_x

	obstacles_container.add_child(river)


func _on_timer_timeout():
	spawn_obstacles_or_river()
