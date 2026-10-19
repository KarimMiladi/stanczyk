extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sprite.modulate = Color(0.0, 0.906, 0.741, 0.502)
	var tween = create_tween()
	tween.tween_property(
		sprite,
		"modulate:a",
		0.0,
		0.25
	)
	tween.parallel().tween_property(
		sprite,
		"scale",
		Vector2(0.8, 0.8),
		0.25
	)
	await tween.finished
	queue_free()
