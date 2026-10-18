extends Area2D

var speed:float = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	if (position.y > get_viewport_rect().size.y + 50):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("lose_hp"):
		body.lose_hp()
		queue_free()
