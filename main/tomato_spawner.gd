extends Node2D

@export var tomato: PackedScene
@onready var timer: Timer = $Timer
@onready var banana_timer: Timer = $BananaTimer
@export var rows: int = 10
@export var width: float = 1280

var elapsed_time: float = 0.0

@export var starting_spawn_interval: float = 1.5
@export var minimum_spawn_interval: float = 0.3
@export var difficulty_increase_interval: float = 5.0

@export var starting_min_speed: float = 150.0
@export var starting_max_speed: float = 350.0
@export var speed_increase: float = 20.0

var current_min_speed: float
var current_max_speed: float

@export var banana: PackedScene
	
func _ready() -> void:
	if tomato == null:
		push_error("Tomato scene is not assigned in the Inspector.")
		return
	current_min_speed = starting_min_speed
	current_max_speed = starting_max_speed
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = starting_spawn_interval
	timer.start()
	banana_timer.timeout.connect(_on_banana_timer_timeout)
	banana_timer.wait_time = randf_range(4.0, 10.0)
	banana_timer.start()


func _process(delta: float) -> void:
	elapsed_time += delta
	var difficulty_level := int(
		elapsed_time / difficulty_increase_interval
	)
	current_min_speed = starting_min_speed + difficulty_level * speed_increase
	current_max_speed = starting_max_speed + difficulty_level * speed_increase
	timer.wait_time = maxf(
		starting_spawn_interval - difficulty_level * 0.1,
	   	minimum_spawn_interval
	)



func _on_timer_timeout() -> void:
	if tomato == null:
		return
	var landing_x := randf_range(50.0, width - 50.0)
	var landing_y := randf_range(400.0, 680.0)
	spawn_tomato(Vector2(landing_x, landing_y))

func spawn_tomato(landing_position: Vector2) -> void:
	if tomato == null:
		return
	var instance = tomato.instantiate()
	instance.min_speed = current_min_speed
	instance.max_speed = current_max_speed
	add_child(instance)
	instance.global_position = landing_position

func _on_banana_timer_timeout() -> void:
	if banana == null:
		return
	var instance = banana.instantiate()
	instance.min_speed = current_min_speed
	instance.max_speed = current_max_speed
	var landing_x := randf_range(50.0, width - 50.0)
	var landing_y := randf_range(400.0, 680.0)
	add_child(instance)
	instance.global_position = Vector2(landing_x, landing_y)
	# Choose a new random interval for the next banana.
	banana_timer.wait_time = randf_range(4.0, 10.0)
	banana_timer.start()
