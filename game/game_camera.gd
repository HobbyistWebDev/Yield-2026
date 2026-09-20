extends Camera2D
class_name GameCamera

@export_category("Shake Strength")
## High value = violent pixel displacement
@export var max_offset: Vector2 = Vector2(80.0, 80.0)
## High value = heavy screen tilt (degrees)
@export var max_roll: float = 15.0
## How fast it fades out (Lower = longer shake duration)
@export var decay_rate: float = 1.2
## Frequency speed of the jitter (Higher = fast violent vibration)
@export var noise_speed: float = 120.0

@export_category("Camera Settings")
## Animation name for the level intro.
@export var camera_animation:String
## Text to display for the level name in the intro.
@export var level_name:String = ""
## Camera's minimum X position.
@export var left_boundary:int
## Camera's maximum X position
@export var right_boundary:int
## Max speed to follow the player
@export var follow_speed = 2.5

@onready var player:Player = get_tree().get_first_node_in_group("player")

var follow:bool = false

var trauma: float = 0.0
var noise: FastNoiseLite
var noise_y: float = 0.0

func _ready() -> void:
	enabled = true
	noise = FastNoiseLite.new()
	noise.seed = randi()
	# High frequency creates sharp, violent directional shifts instead of smooth motion
	noise.frequency = 0.5
	
	limit_left = left_boundary
	limit_right = right_boundary
	$LevelName.text = level_name
	
	#$AnimationPlayer.play(camera_animations[LevelManager.current_level])
	$AnimationPlayer.play(camera_animation)
	await($AnimationPlayer.animation_finished)
	player.can_move = true
	follow = true
	$AnimationPlayer.play("start")

func _process(delta: float) -> void:
	if follow:
		var new_pos:Vector2 = player.position
		if player.dir == 1:
			new_pos.x += 300
		else:
			new_pos.x -= 300
		position = position.lerp(new_pos, delta * follow_speed)
	
	
	if trauma > 0.0:
		trauma = max(trauma - decay_rate * delta, 0.0)
		_apply_shake(delta)
	elif offset != Vector2.ZERO or rotation != 0.0:
		offset = Vector2.ZERO
		rotation = 0.0

func _apply_shake(delta: float) -> void:
	# Linear (trauma) instead of pow() gives a much harder, instant punch
	var amount = trauma 
	noise_y += delta * noise_speed
	
	rotation = deg_to_rad(max_roll * amount * noise.get_noise_2d(0, noise_y))
	offset.x = max_offset.x * amount * noise.get_noise_2d(100, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(200, noise_y)

## Call shake(1.0) for maximum punch
func shake(amount: float = 1.0) -> void:
	trauma = min(trauma + amount, 1.0)
