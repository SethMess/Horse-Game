extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -120.0
const GRAVITY = 300.0

var z_position = 0.0  # Height above ground (0 is on ground, negative is up)
var z_velocity = 0.0

@onready var sprite = $AnimatedSprite2D # Make sure this is the actual name of your sprite node

func _physics_process(delta):
	# Handle 4-direction movement
	var direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	velocity = direction.normalized() * SPEED

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and z_position == 0:
		z_velocity = JUMP_VELOCITY
		#SET TO JUMP ANIMATION

	# Apply gravity and jump height
	if z_position < 0 or z_velocity != 0:
		z_velocity += GRAVITY * delta
		z_position += z_velocity * delta

		# Land on the ground
		if z_position > 0:
			z_position = 0
			z_velocity = 0

	# Move player on X/Y freely
	move_and_slide()

	# Apply sprite visual height offset (z_position is negative when "in the air")
	sprite.position.y = z_position

	# Squash & Stretch
	apply_squash_and_stretch()

func apply_squash_and_stretch():
	if z_velocity < 0: # Going Up
		sprite.scale = Vector2(1.2, 0.8) # Stretch
	elif z_velocity > 0: # Falling Down
		sprite.scale = Vector2(0.8, 1.2) # Squash
	else:
		sprite.scale = Vector2(1, 1) # Normal when grounded
