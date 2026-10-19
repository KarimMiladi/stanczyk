extends CharacterBody2D

var speed = 300.0
const DASH_SPEED = 900.0
const DASH_DURATION = 0.2

var hp: int = 3
var game_over: bool = false

var is_dashing: bool = false
var dash_direction: float = 0.0
var dash_timer: float = 0.0

const DASH_COOLDOWN = 1.0
var dash_cooldown_timer: float = 0.0

const DASH_TRAIL = preload("res://dash_trail/dash_trail.tscn")
const TRAIL_INTERVAL = 0.04
var trail_timer: float = 0.0

@onready var sprite = $AnimatedSprite2D
var last_facing: String = "front"

func _ready() -> void:
	sprite.play("idlefront")

func damage_flash() -> void:
	var tween = create_tween()
	sprite.modulate = Color.RED
	tween.tween_property(
		sprite,
		"modulate",
		Color.WHITE,
		0.3
	)


func _physics_process(delta: float) -> void:
	if game_over:
		return
	# Reduce dash cooldown
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	# Get movement input (left/right and up/down)
	var direction := Input.get_vector("left", "right", "up", "down")
	# Start dash only if cooldown has finished
	if Input.is_action_just_pressed("dash") \
	and not is_dashing \
	and dash_cooldown_timer <= 0:
		if direction != Vector2.ZERO:
			dash_direction = direction.x
			velocity = direction * DASH_SPEED
		else:
			dash_direction = 1.0 if sprite.animation != "runleft" else -1.0
			velocity = Vector2(dash_direction, 0) * DASH_SPEED
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_cooldown_timer = DASH_COOLDOWN
		trail_timer = 0.0
	# Dash movement
	if is_dashing:
		trail_timer -= delta
		if trail_timer <= 0:
			spawn_dash_trail()
			trail_timer = TRAIL_INTERVAL
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	# Normal movement
	else:
		velocity = direction * speed
		if direction.x < 0:
			last_facing = "left"
			sprite.play("runleft")
		elif direction.x > 0:
			last_facing = "right"
			sprite.play("runright")
		elif direction.y < 0:
			last_facing = "back"
			sprite.play("idleback")
		elif direction.y > 0:
			last_facing = "front"
			sprite.play("idlefront")
		else:
			match last_facing:
				"left":
					sprite.play("runleft")
					sprite.pause()
				"right":
					sprite.play("runright")
					sprite.pause()
				"back":
					sprite.play("idleback")
				_:
					sprite.play("idlefront")
	move_and_slide()


func spawn_dash_trail() -> void:
	var trail = DASH_TRAIL.instantiate()
	get_tree().current_scene.add_child(trail)
	trail.global_position = sprite.global_position
	var trail_sprite: AnimatedSprite2D = trail.get_node("AnimatedSprite2D")
	trail_sprite.sprite_frames = sprite.sprite_frames
	trail_sprite.rotation = sprite.global_rotation
	trail_sprite.scale = sprite.global_scale

func lose_hp() -> void:
	if game_over:
		return
	hp -= 1
	var main = $"../.."
	# Your existing damage flash can go here
	damage_flash()
	main.update_hearts(hp)
	if hp <= 0:
		game_over = true
		if main.has_method("game_over"):
			main.game_over()
		return
	if main.has_method("shake_world"):
		main.shake_world(8.0, 0.3)
