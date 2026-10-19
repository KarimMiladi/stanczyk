extends Node2D

@export var tomato: PackedScene
@onready var timer: Timer = $Timer

@export var rows: int = 10
var width: float = 850.0

var elapsed_time: float = 0.0

# Difficulty settings
@export var starting_spawn_interval: float = 1.5
@export var minimum_spawn_interval: float = 0.3
@export var difficulty_increase_interval: float = 5.0

@export var starting_min_speed: float = 150.0
@export var starting_max_speed: float = 350.0
@export var speed_increase: float = 20.0

var current_min_speed: float
var current_max_speed: float


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	current_min_speed = starting_min_speed
	current_max_speed = starting_max_speed
	timer.wait_time = starting_spawn_interval
	timer.start()


func _process(delta: float) -> void:
	elapsed_time += delta
	var difficulty_level = int(
		elapsed_time / difficulty_increase_interval
	)
	# Increase tomato speeds as time passes
	current_min_speed = starting_min_speed + difficulty_level * speed_increase
	current_max_speed = starting_max_speed + difficulty_level * speed_increase
	# Spawn tomatoes more frequently
	timer.wait_time = maxf(
		starting_spawn_interval - difficulty_level * 0.1,
		minimum_spawn_interval
	)

func _on_timer_timeout() -> void:
	if tomato:
		var instance = tomato.instantiate()
		instance.min_speed = current_min_speed
		instance.max_speed = current_max_speed
		add_child(instance)
		var landing_x = randf_range(50, width + 50)
		var landing_y = randf_range(250.0, 450.0)
		instance.global_position = Vector2(
			landing_x,
			landing_y
		)
