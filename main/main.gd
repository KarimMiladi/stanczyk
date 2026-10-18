extends Node2D

signal game_over

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1
	$GameOver.visible = false
	$Node2D.modulate.a = 1
	$Clown.modulate.a = 1
	$tomato_spawner.modulate.a = 1

func _on_game_over() -> void:
	Engine.time_scale = 0.5
	$GameOver.visible = true
	$Node2D.modulate.a = 0.5
	$Clown.modulate.a = 0.5
	$tomato_spawner.modulate.a = 0.5
