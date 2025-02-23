extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -130.0
const GRAVITY = 300.0

var z_position = 0.0  # Height above ground (0 is on ground, negative is up)
var z_velocity = 0.0

@onready var sprite = $AnimatedSprite2D # Make sure this is the actual name of your sprite node
@onready var collision_shape = $CollisionShape2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var shadow_sprite = $Shadow

signal player_jumped
#signal player_hit

func _ready():
	#this.connect(player_hit)
	#collision_shape.connect("_on_body_entered", ) ####################GET THIS CONNECTED
	pass
	

func _physics_process(delta):
	# Handle 4-direction movement
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	velocity = direction.normalized() * SPEED

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and z_position == 0:
		jump()

	z_axis_stuff(delta)

	# Move player on X/Y freely
	move_and_slide()

	# Apply sprite visual height offset (z_position is negative when "in the air")
	sprite.position.y = z_position
	shadow_shrink(shadow_sprite, z_position)
	# Squash & Stretch
	apply_squash_and_stretch()


func shadow_shrink(shadow, z):
	# Make shadow smaller and more transparent as the horse jumps
	shadow.scale = Vector2(2, 2) * (1 + (z / 80.0))
	shadow.modulate.a = clamp(1 + (z / 200.0), 0.3, 1.0)

func jump():
	player_jumped.emit()
	z_velocity = JUMP_VELOCITY
	collision_shape.disabled = true
	#SET TO JUMP ANIMATION
	sprite.play("purple_jump")
	
	

func flash_red(is_game_over):
	# Set the flash uniform to 1
	sprite.material.set("shader_param/flash_strength", 1.0)
	
	# Create a one-shot timer and wait for 0.5 seconds before resetting the flash
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	sprite.material.set("shader_param/flash_strength", 0.0)
	if is_game_over:
		queue_free()


#func flash_red():
	## Get the player's shader material (assuming it’s on $Sprite2D)
	#var material = $Sprite2D.material
	#material.set("shader_param/flash_strength", 1.0)
	## Create a tween to interpolate flash_strength from 1 to 0 over 0.5 seconds.
	

	
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
			sprite.play("purple_run")

func apply_squash_and_stretch():
	if z_velocity < 0: # Going Up
		sprite.scale = Vector2(1.2, 0.8) # Stretch
	elif z_velocity > 0: # Falling Down
		sprite.scale = Vector2(0.8, 1.2) # Squash
	else:
		sprite.scale = Vector2(1, 1) # Normal when grounded
