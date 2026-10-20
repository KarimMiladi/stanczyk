extends Node2D

var is_game_over: bool = false
var original_world_position: Vector2
var shake_tween: Tween

@onready var world = $World
@onready var game_over_ui = $GameOver
@onready var restart_button = $GameOver/Button

@onready var heart1 = $CanvasLayer/HBoxContainer/TextureRect/Heart1
@onready var heart2 = $CanvasLayer/HBoxContainer/TextureRect2/Heart2
@onready var heart3 = $CanvasLayer/HBoxContainer/TextureRect3/Heart3

@onready var game_time_label: Label = $CanvasLayer/GameTime
var elapsed_time: float = 0.0

const CROWD_POPUP = preload("res://crowd_popup/crowd_popup.tscn")
@onready var crowd_timer: Timer = $CrowdTimer

var game_started: bool

var crowd_messages: Array[String] = [
	"Take This!",
	"Boooooo",
	"I Hate You!",
	"Arrest Him!",
	"Worst Performance",
	"You're Not a Clown,
	You're The Entire Circus",
	"My Eyes",
	"I Can Do Better Than Him",
	"#CINEEEE_RADIOOOOOO :)",
	"Never Come Back Again!",
	"Quit!",
	"Help Me!",
	"Could This Be...",
	"He's a Murderer!!!",
	"I Know This Guy...",
	"Wait...",
	]

func show_crowd_popup() -> void:
	var popup = CROWD_POPUP.instantiate()
	popup.get_node("Label").text = crowd_messages.pick_random()
	$CanvasLayer.add_child(popup)
	popup.position = Vector2(
		randf_range(150.0, 1100.0),
		randf_range(50.0, 260.0)
	)

func _process(delta: float) -> void:
	if is_game_over and not game_started:
		return
	elapsed_time += delta
	var total_seconds := int(elapsed_time)
	var minutes := total_seconds / 60
	var seconds := total_seconds % 60
	game_time_label.text = "Time: %02d:%02d" % [minutes, seconds]

func update_hearts(hp: int) -> void:
	heart1.visible = hp >= 1
	heart2.visible = hp >= 2
	heart3.visible = hp >= 3


func play_heart_break(hp: int) -> void:
	var hearts = [heart1, heart2, heart3]
	var lost_heart_index = hp
	if lost_heart_index < 0 or lost_heart_index >= hearts.size():
		return
	var heart: AnimatedSprite2D = hearts[lost_heart_index]
	heart.visible = true
	heart.play("break")
	await heart.animation_finished
	heart.visible = false


func _ready() -> void:
	game_started = true
	Engine.time_scale = 1.0
	original_world_position = world.position
	update_hearts(3)
	crowd_timer.wait_time = randf_range(3.0, 6.0)
	crowd_timer.timeout.connect(_on_crowd_timer_timeout)
	crowd_timer.start()

func _on_crowd_timer_timeout() -> void:
	if is_game_over:
		crowd_timer.stop()
		return
	show_crowd_popup()
	crowd_timer.wait_time = randf_range(3.0, 6.0)
	crowd_timer.start()

func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	game_started = false
	GameData.survival_time = elapsed_time
	game_over_sequence()

func game_over_sequence() -> void:
	# Slow motion
	Engine.time_scale = 0.4
	# Long, powerful final shake
	await shake_world(22.0, 2.5)
	# Freeze gameplay only after the shake finishes
	Engine.time_scale = 0.0
	# Show the Game Over UI
	Transition.game_over()


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
