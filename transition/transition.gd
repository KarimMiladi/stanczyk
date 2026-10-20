extends CanvasLayer

@onready var curtain: AnimatedSprite2D = $Curtain

var transitioning: bool = false

func _ready() -> void:
	curtain.visible = false


func main_menu() -> void:
	curtain.visible = true
	if transitioning:
		return
	transitioning = true
	Engine.time_scale = 1.0
	curtain.visible = true
	curtain.play("close")
	await curtain.animation_finished
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
	# Wait a frame so the new scene is ready.
	await get_tree().process_frame
	curtain.play("open")
	await curtain.animation_finished
	curtain.visible = false
	transitioning = false

func to_game() -> void:
	curtain.visible = true
	if transitioning:
		return
	transitioning = true
	Engine.time_scale = 1.0
	curtain.visible = true
	curtain.play("close")
	await curtain.animation_finished
	get_tree().change_scene_to_file("res://main/main.tscn")
	# Wait a frame so the new scene is ready.
	await get_tree().process_frame
	curtain.play("open")
	await curtain.animation_finished
	curtain.visible = false
	transitioning = false

func game_over() -> void:
	curtain.visible = true
	if transitioning:
		return
	transitioning = true
	Engine.time_scale = 1.0
	curtain.visible = true
	curtain.play("close")
	await curtain.animation_finished
	get_tree().change_scene_to_file("res://game_over/game_over.tscn")
	# Wait a frame so the new scene is ready.
	await get_tree().process_frame
	curtain.play("open")
	await curtain.animation_finished
	curtain.visible = false
	transitioning = false
