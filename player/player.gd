extends CharacterBody2D
class_name Player

@export var can_move:bool = false

@onready var timer: Timer = $Timer
@onready var blood_particle: CPUParticles2D = $BloodParticle
@export var is_tutorial:bool = false


var horizontal_speed = 500
var gravity = 3000
var braking = 1000

#right = 1 left = -1
var dir = 1
var is_jumping = false

var jump_floor = 0.8
var jump_vel = -1000
var mega_jump_floor = 0.3
var mega_jump_vel = -1500

var do_yield_action = false
var remaining_time: float = 0

@onready var charge_bar_anim:AnimationPlayer = get_tree().get_first_node_in_group("charge_bar")

@onready var left_cast: RayCast2D = $LeftCast
@onready var right_cast: RayCast2D = $RightCast
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var run_particle: CPUParticles2D = $RunParticle
var game_camera: GameCamera

var orig_scale = 0

func _ready():
	orig_scale = anim_sprite.scale.x
	game_camera = get_tree().current_scene.get_node("GameCamera")
	anim_sprite.play("idle_front")

var did_pass_jump = false
var did_pass_mega_jump = false
func _process(delta: float) -> void:
	if not timer.is_stopped() and timer.time_left < jump_floor and not did_pass_jump:
		did_pass_jump = true
		AudioManager.play("mini_jump_notify")
	if not timer.is_stopped() and timer.time_left < mega_jump_floor and not did_pass_mega_jump:
		did_pass_mega_jump = true
		AudioManager.play("mega_jump_notify")

func _physics_process(delta: float) -> void:
	if !can_move:
		return
	
	if dir == 1:
		anim_sprite.scale.x = orig_scale
		run_particle.direction.x = -1
	if dir == -1:
		anim_sprite.scale.x = -orig_scale
		run_particle.direction.x = 1
	
	if left_cast.is_colliding() and timer.is_stopped():
		AudioManager.play("bump")
		dir = 1
	if right_cast.is_colliding() and timer.is_stopped():
		AudioManager.play("bump")
		dir = -1
	
	if is_on_floor():
		is_jumping = false
		anim_sprite.play("running")
		anim_sprite.offset.y = 0
	
	if is_on_floor() and timer.is_stopped():
		run_particle.emitting = true
	else: 
		run_particle.emitting = false
		
	if is_jumping:
		anim_sprite.offset.y = 7

	if not is_on_floor() and is_jumping and velocity.y > 0.1:
		anim_sprite.play("falling")
	
	velocity.y += gravity * delta
	if not is_jumping and not is_on_floor() and velocity.y > 1:
		velocity.x = 0

	if Input.is_action_just_pressed("yield"):
		timer.start()
		charge_bar_anim.play("fill")

	if Input.is_action_just_released("yield"):
		do_yield_action = true
		remaining_time = timer.time_left
		timer.stop()
		charge_bar_anim.play("cancel")
		did_pass_jump = false
		did_pass_mega_jump = false

	if not timer.is_stopped() and not is_jumping:
		velocity.x = move_toward(velocity.x, 0, 1000 * delta)
		anim_sprite.play("yielding")
	else:
		velocity.x = horizontal_speed * dir
	
	if do_yield_action:
		do_yield_action = false
		yield_action(remaining_time)
		
	move_and_slide()

func yield_action(rm):
	if rm < mega_jump_floor and not rm < 0.01 and not is_jumping:
		velocity.y = mega_jump_vel
		is_jumping = true
		anim_sprite.play("mega_jumping")
		AudioManager.play("mega_jump")
		game_camera.shake(0.2)
		return
	if rm < jump_floor and not rm < 0.01 and not is_jumping:
		velocity.y = jump_vel
		is_jumping = true
		anim_sprite.play("jumping")
		AudioManager.play("jump")
		return

func _on_timer_timeout() -> void:
	dir *= -1
	remaining_time = 1

func die():
	game_camera.shake(5000)
	AudioManager.play("death")
	
	if is_tutorial:
		position = Vector2(3300, -130)
		return
	
	blood_particle.emitting = true
	anim_sprite.visible = false
	LevelManager.restart_level(1)
	process_mode = Node.PROCESS_MODE_DISABLED
