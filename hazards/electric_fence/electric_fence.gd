extends HurtBox

@onready var left_post: Sprite2D = $LeftPost
@onready var right_post: Sprite2D = $RightPost
@onready var left_particle: CPUParticles2D = $ColorRect/left_particle
@onready var right_particle: CPUParticles2D = $ColorRect/right_particle
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var color_rect: ColorRect = $ColorRect
@export var length = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_post.position.x -= length/2
	right_post.position.x += length/2
	(collision_shape.shape as RectangleShape2D).size.x = length
	left_particle.global_position = left_post.global_position
	right_particle.global_position = right_post.global_position
	# Use global positions to make sure you get correct coordinates regardless of parent offsets
	var left_pos = left_post.global_position
	var right_pos = right_post.global_position

	var left_x = min(left_pos.x, right_pos.x)
	var right_x = max(left_pos.x, right_pos.x)
	var tots_width = right_x - left_x

	# Convert global coordinate back into this Node2D's local coordinate space
	var local_left_x = to_local(Vector2(left_x, 0)).x

	# Set position and size
	color_rect.position = Vector2(local_left_x + 15, -30)
	color_rect.size = Vector2(tots_width, 50)
