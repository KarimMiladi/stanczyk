extends Node2D

@export var tomato: PackedScene

@onready var timer: Timer = $Timer

@export var rows: int = 10
var width: float = 850
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if tomato:
		var instance = tomato.instantiate()
		add_child(instance)
		instance.global_position = Vector2(randi_range(0,rows-1) * (width/rows)  + 100, -23)
