extends Area2D

@export var min_speed: float = 150.0
@export var max_speed: float = 350.0
@export var fall_height: float = 600.0
@export var ground_duration: float = 5.0
@export var warning_time: float = 0.6
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var speed: float
var falling: bool = true

@onready var indicator: Sprite2D = $Indicator

func _ready() -> void:
	speed = randf_range(min_speed, max_speed)
	sprite.position = Vector2(0, -fall_height)
	sprite.play("falling")
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
	sprite.position.y += speed * delta
	if sprite.position.y >= 0:
		land()

func land() -> void:
	falling = false
	sprite.position.y = 0
	if sprite.sprite_frames.has_animation("impact"):
		sprite.play("impact")
	else:
		sprite.stop()
	indicator.modulate.a = 0.0
	# Enable collision after landing.
	$CollisionShape2D.set_deferred("disabled", false)
	await get_tree().create_timer(ground_duration).timeout
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Legs" and not falling:
		var player = area.get_parent()
		if player.has_method("slip"):
			player.slip()
			queue_free()
