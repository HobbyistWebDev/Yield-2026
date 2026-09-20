extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var timer: Timer = $Timer

var player: Player 
var is_closed: bool = true
var dist_to_open: float = 500

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player") as Player
	animated_sprite.play("close")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.can_move = false
		body.get_node("InfoLabel").visible = true
		await(get_tree().create_timer(1.5).timeout)
		LevelManager.go_to_next_level()

func _on_timer_timeout() -> void:
	if not is_instance_valid(player):
		return

	# Point raycast at player AND force an immediate physics refresh
	raycast.target_position = raycast.to_local(player.global_position)
	raycast.force_raycast_update()

	var col = raycast.get_collider()

	# Only change door state if the raycast actually hit a valid object
	if col != null:
		var dist = (col.global_position - global_position).length()

		if col is Player and is_closed and dist < dist_to_open:
			animated_sprite.play("open")
			is_closed = false
		elif not (col is Player) and not is_closed:
			animated_sprite.play("close")
			is_closed = true
