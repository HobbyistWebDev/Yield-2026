extends CharacterBody2D
class_name Player

@onready var timer: Timer = $Timer

var horizontal_speed = 500
var gravity = 3000

#right = 1 left = -1
var dir = 1
var is_jumping = false

var jump_floor = 0.8
var jump_vel = -1000
var mega_jump_floor = 0.3
var mega_jump_vel = -1500

var do_yield_action = false
var remaining_time: float = 0

@onready var left_cast: RayCast2D = $LeftCast
@onready var right_cast: RayCast2D = $RightCast

func _physics_process(delta: float) -> void:
	if left_cast.is_colliding():
		dir = 1
	if right_cast.is_colliding():
		dir = -1
	
	if is_on_floor():
		is_jumping = false
	
	velocity.x = horizontal_speed * dir
	velocity.y += gravity * delta
	if not is_jumping and not is_on_floor() and velocity.y > 1:
		velocity.x = 0

	if Input.is_action_just_pressed("yield"):
		timer.start()

	if Input.is_action_just_released("yield"):
		do_yield_action = true
		remaining_time = timer.time_left
		timer.stop()

	if not timer.is_stopped() and not is_jumping:
		velocity.x = 0
	
	if do_yield_action:
		do_yield_action = false
		yield_action(remaining_time)
		
	move_and_slide()

func yield_action(rm):
	if rm < mega_jump_floor and not rm < 0.01 and not is_jumping:
		velocity.y = mega_jump_vel
		is_jumping = true
		return
	if rm < jump_floor and not rm < 0.01 and not is_jumping:
		velocity.y = jump_vel
		is_jumping = true
		return

func _on_timer_timeout() -> void:
	dir *= -1
	remaining_time = 1
