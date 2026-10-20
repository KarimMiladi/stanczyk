extends Control

@onready var time_label: Label = $TimeLabel

func _ready() -> void:
	var seconds := int(GameData.survival_time)
	var minutes := seconds / 60
	var remaining_seconds := seconds % 60
	time_label.text = "Survived: %02d:%02d" % [
		minutes,
		remaining_seconds
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_main_menu_pressed() -> void:
	Transition.main_menu()
