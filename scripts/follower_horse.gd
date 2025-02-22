# HorseFollower.gd
extends CharacterBody2D

@export var follow_speed: float = 5.0
@export var position_offset: Vector2 = Vector2.ZERO  # Each follower can have its own offset
@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

@onready var player_horse = $"../player_horse"  # Make sure this path is correct!
var target: Node2D = player_horse
const runs = ["brown_run", "light_brown_run", "yellow_run", "purple_run"]
const jumps = ["brown_jump", "light_brown_jump", "yellow_jump", "purple_jump"]
var index = randi_range(0, runs.size() - 1)

const SPEED = 50.0
const JUMP_VELOCITY = -130.0
const GRAVITY = 300.0

var z_position = 0.0  # Height above ground (0 is on ground, negative is up)
var z_velocity = 0.0

func set_color(i):
	index = i

func _ready():
	#position = Vector2(-30, 50)
	sprite.play(runs[index])

func _physics_process(delta):
	if target:
		# Compute the desired position: target's position plus the offset.
		var desired_pos = target.position + position_offset
		
		# Calculate the vector from current position to the desired position.
		var diff = desired_pos - position
		
		# Set velocity to move towards the desired position.
		# Multiplying the difference by follow_speed controls how fast the follower catches up.
		velocity = diff * follow_speed
		z_axis_stuff(delta)
		sprite.position.y = z_position

		apply_squash_and_stretch()
		
		move_and_slide()



func jump():
	if self != null and collision_shape != null:
		z_velocity = JUMP_VELOCITY
		collision_shape.disabled = true
		#SET TO JUMP ANIMATION
		sprite.play(jumps[index])



func z_axis_stuff(delta):
		# Apply gravity and jump height
	if z_position < 0 or z_velocity != 0:
		z_velocity += GRAVITY * delta
		z_position += z_velocity * delta

		# Land on the ground
		if z_position > 0:
			z_position = 0
			z_velocity = 0
			
			collision_shape.disabled = false
			sprite.play(runs[index])


func apply_squash_and_stretch():
	if z_velocity < 0: # Going Up
		sprite.scale = Vector2(1.2, 0.8) # Stretch
	elif z_velocity > 0: # Falling Down
		sprite.scale = Vector2(0.8, 1.2) # Squash
	else:
		sprite.scale = Vector2(1, 1) # Normal when grounded
