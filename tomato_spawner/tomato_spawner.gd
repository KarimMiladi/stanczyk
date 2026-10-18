extends Node2D

@export var tomato_scene: PackedScene
@export var spawn_interval: float = 3.0

func _ready() -> void:
	spawn_tomato()
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_tomato)
	add_child(timer)
	timer.start()

func spawn_tomato() -> void:
	var tomato = tomato_scene.instantiate()
	var screen_width = get_viewport_rect().size.x
	tomato.position = Vector2(randf_range(30.0, screen_width - 30.0),-50.0)
	add_child(tomato)
