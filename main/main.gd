extends Node2D


signal game_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_timer_timeout():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_over() -> void:
	Engine.time_scale = 0.5
