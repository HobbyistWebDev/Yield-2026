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

var trauma: float = 0.0
var noise: FastNoiseLite
var noise_y: float = 0.0

func _ready() -> void:
	enabled = true
	noise = FastNoiseLite.new()
	noise.seed = randi()
	# High frequency creates sharp, violent directional shifts instead of smooth motion
	noise.frequency = 0.5

func _process(delta: float) -> void:
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
