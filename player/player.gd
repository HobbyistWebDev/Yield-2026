class_name Player
extends CharacterBody2D


var speed = 200.0
var jump_vel = 240.0

var yield_timer : float = 0
#delay direction change to avoid clinging to walls
var directionChangeBuffer : float = 0 

var direction : int = -1
var movement_state : int = 0
# 0 is run
# 1 is yield
# 2 is jump

var nerf_speed : bool = false #for when doing a high jump

#specifically for allowing a flip while yield is still pressed
var still_pressing_yield : bool = false 

func _process(delta: float) -> void:
	directionChangeBuffer -= 1 #keep timer going down
	
	if nerf_speed:
		speed = 60
	else:
		speed = 200
	

func _physics_process(delta: float) -> void:
	
	if movement_state == 0: #run
		if is_on_floor():
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			
	if movement_state == 1: #yielding
		yield_timer += 1 #count up
		velocity.x *= 0.1 #slow to a halt
		
		if yield_timer == 20: #count up at least 20 ticks before checking anything
			if not Input.is_action_pressed("yield"): #yield is not pressed
				yield_timer = 0
				movement_state = 0
		#vvv yield has been pressed long enough for action to happen
		elif yield_timer >= 20 and not Input.is_action_pressed("yield"): 
			if (yield_timer < 40): #arc jump
				movement_state = 2
				velocity.y = jump_vel * -1.25
			elif (yield_timer < 60): #high jump
				movement_state = 2
				velocity.y = jump_vel * -1.75
				nerf_speed = true
			yield_timer = 0
		if yield_timer >= 60: #flip
			direction *= -1
			movement_state = 0
			yield_timer = 0
			
	
	if movement_state == 2: #jump
		velocity.x = direction * speed
		
		if is_on_floor() and velocity.y >= 0: #when landing
			movement_state = 0
	else:
		nerf_speed = false
	
	if Input.is_action_pressed("yield") and is_on_floor() and not still_pressing_yield:
		movement_state = 1
		still_pressing_yield = true
			
	else:
		if is_on_wall() and directionChangeBuffer <= 0: #wall bouncing when running or jumping
			direction *= -1
			velocity.x *= -1
			directionChangeBuffer = 10 #set delay
	
	#this is here to prevent player from yielding immediately into a flip
	if Input.is_action_just_released("yield"):
		still_pressing_yield = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
