extends "res://scripts/obstaclebase.gd"

#extends Area2D
# HorseCollectible.gd
const idles = ["brown_idle", "light_brown_idle", "yellow_idle", "purple_idle"]
var index = randi_range(0, idles.size() - 1)

@onready var sprite = $AnimatedSprite2D

signal collected(position: Vector2, i: int)

func _ready():
	#super()
	sprite.play(idles[index])
	var collected_collable = Callable(self, "_on_horse_body_entered")
	self.connect("body_entered", collected_collable)
	#print(collected_collable)
	#body_entered.connect(_on_body_entered)

func _process(delta):
	super(delta)

func _on_horse_body_entered(body):
	#print("horse ON HORSE COLLISION, POSITION" + str(position))
	if body.is_in_group("Player"):  # Make sure your player is in group "Player"
		#emit_signal("collected", position)
		collected.emit(position, index)
		queue_free()
