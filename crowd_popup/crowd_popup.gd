extends Node2D

@export var duration: float = 3
@export var horizontal_padding: float = 48.0
@export var vertical_padding: float = 24.0

@onready var label: Label = $Label
@onready var texture: TextureRect = $TextureRect


func _ready() -> void:
	resize_popup()
	# Start slightly transparent.
	modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.8, 0.5)
	tween.tween_interval(duration - 0.5)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	queue_free()

func resize_popup() -> void:
	label.reset_size()
	var text_size: Vector2 = label.get_minimum_size()
	var bubble_size := Vector2(
		text_size.x + horizontal_padding,
		text_size.y + vertical_padding
	)
	# Resize the bubble.
	texture.size = bubble_size
	# Center both nodes around the popup's origin.
	texture.position = -bubble_size / 2.0
	label.position = -text_size / 2.0
	# Keep the text centered inside the bubble.
	label.position = texture.position + (bubble_size - text_size) / 2.0
	label.size = text_size
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
