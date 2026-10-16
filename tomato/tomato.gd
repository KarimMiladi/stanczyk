extends Area2D

var direction:Vector2
var speed:float = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(100,0)
	direction = Vector2.DOWN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("lose_hp"):
		body.lose_hp()
