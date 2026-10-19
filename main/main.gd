extends Node2D

var is_game_over: bool = false
var original_world_position: Vector2
var shake_tween: Tween

@onready var world = $World
@onready var game_over_ui = $GameOver
@onready var restart_button = $GameOver/Button

@onready var heart1 = $CanvasLayer/HBoxContainer/TextureRect/Sprite2D
@onready var heart2 = $CanvasLayer/HBoxContainer/TextureRect2/Sprite2D
@onready var heart3 = $CanvasLayer/HBoxContainer/TextureRect3/Sprite2D

func update_hearts(hp: int) -> void:
	heart1.visible = hp >= 1
	heart2.visible = hp >= 2
	heart3.visible = hp >= 3

func _ready() -> void:
	Engine.time_scale = 1.0
	original_world_position = world.position
	game_over_ui.visible = false
	restart_button.visible = false
	update_hearts(3)

func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	game_over_sequence()

func game_over_sequence() -> void:
	# Slow motion
	Engine.time_scale = 0.35
	# Long, powerful final shake
	await shake_world(22.0, 1.2)
	# Freeze gameplay only after the shake finishes
	Engine.time_scale = 0.0
	# Show the Game Over UI
	game_over_ui.visible = true
	game_over_ui.modulate.a = 0.0
	var fade = create_tween()
	fade.set_ignore_time_scale(true)
	fade.tween_property(
		game_over_ui,
		"modulate:a",
		1.0,
		0.6
	)
	await fade.finished
	# Show the restart button
	restart_button.visible = true
	restart_button.modulate.a = 0.0
	var button_tween = create_tween()
	button_tween.set_ignore_time_scale(true)
	button_tween.tween_property(
		restart_button,
		"modulate:a",
		1.0,
		0.4
	)

func shake_world(
	intensity: float = 8.0,
	duration: float = 0.3
) -> void:
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
	world.position = original_world_position
	shake_tween = create_tween()
	shake_tween.set_ignore_time_scale(true)
	var steps = int(duration / 0.03)
	for i in range(steps):
		var strength = intensity * (1.0 - float(i) / steps)
		var offset = Vector2(
			randf_range(-strength, strength),
			randf_range(-strength, strength)
		)
		shake_tween.tween_property(
			world,
			"position",
			original_world_position + offset,
			0.03
		)
	shake_tween.tween_property(
		world,
		"position",
		original_world_position,
		0.05
	)
	await shake_tween.finished

func _on_button_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()
