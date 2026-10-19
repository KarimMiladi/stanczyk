
extends Area2D

@export var min_speed: float = 150.0
@export var max_speed: float = 350.0

@export var warning_time: float = 0.6
@export var fall_height: float = 600.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var indicator: Sprite2D = $Indicator

var speed: float
var elapsed: float = 0.0
var landing_position: Vector2
var falling: bool = false

func _ready() -> void:
	speed = randf_range(min_speed, max_speed)

	# The spawner gives us the landing position.
	landing_position = global_position

	# Keep the tomato above its landing point visually.
	sprite.position = Vector2(0, -fall_height)

	# Show the landing indicator on the ground.
	indicator.position = Vector2.ZERO
	indicator.modulate.a = 0.0

	# Enable the warning first.
	var tween = create_tween()
	tween.tween_property(
		indicator, "modulate:a", 0.6, 0.2
	)
	await get_tree().create_timer(warning_time).timeout

	if not is_instance_valid(self):
		return

	falling = true

func _physics_process(delta: float) -> void:
	if not falling:
		return

	# Move the tomato visually down toward the ground.
	sprite.position.y += speed * delta

	# Check whether the tomato has reached the ground.
	if sprite.position.y >= 0:
		impact()

func impact() -> void:
	# Damage the player only if their ground position
	# overlaps the impact point.
	for body in get_overlapping_bodies():
		if body.has_method("lose_hp"):
			body.lose_hp()

	queue_free()
