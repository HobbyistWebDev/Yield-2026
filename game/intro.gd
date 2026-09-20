extends Control

@export_category("Shake Strength")
## High value = violent pixel displacement
@export var max_offset: Vector2 = Vector2(80.0, 80.0)
## High value = heavy screen tilt (degrees)
@export var max_roll: float = 15.0
## How fast it fades out (Lower = longer shake duration)
@export var decay_rate: float = 1.2
## Frequency speed of the jitter (Higher = fast violent vibration)
@export var noise_speed: float = 120.0

@export var trauma: float = 0.0
var noise: FastNoiseLite
var noise_y: float = 0.0

func _ready():
	noise = FastNoiseLite.new()
	noise.seed = randi()
	$AnimationPlayer.play("intro")
	$Blinky.play("idle_right")
	await($AnimationPlayer.animation_finished)
	$Blinky.play("yielding")
	await(get_tree().create_timer(1).timeout)
	$Blinky.play("running")
	$AnimationPlayer.play("blinky_exit")
	await($AnimationPlayer.animation_finished)
	SceneTransition.transition("res://level_select/level_select.tscn")

func _process(delta: float) -> void:
	if trauma > 0.0:
		trauma = max(trauma - decay_rate * delta, 0.0)
		_apply_shake(delta)
	elif position != Vector2.ZERO or rotation != 0.0:
		position = Vector2.ZERO
		rotation = 0.0

func _apply_shake(delta: float) -> void:
	# Linear (trauma) instead of pow() gives a much harder, instant punch
	var amount = trauma 
	noise_y += delta * noise_speed
	
	#rotation = deg_to_rad(max_roll * amount * noise.get_noise_2d(0, noise_y))
	position.x = max_offset.x * amount * noise.get_noise_2d(100, noise_y)
	position.y = max_offset.y * amount * noise.get_noise_2d(200, noise_y)

## Call shake(1.0) for maximum punch
func shake(amount: float = 1.0) -> void:
	trauma = min(trauma + amount, 1.0)

func _input(_event:InputEvent):
	if Input.is_action_just_pressed("ui_accept"):
		SceneTransition.transition("res://level_select/level_select.tscn")
