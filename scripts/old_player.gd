extends CharacterBody2D

@export var move_speed = 200.0
@export var jump_height: float = 50
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4
@export var wall_jump_height: float = 50
@export var wall_jump_knockback: float = 50

@export var extra_jump: int
@export_range(0.0, 1.0, 0.01) var movement_smoothing: float = 0.2

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var wall_jump_velocity: float = ((2.0 * wall_jump_height) / jump_time_to_peak) * -1.0
@onready var wall_jump_knockback_velocity: float = ((2.0 * wall_jump_knockback) / jump_time_to_peak) * -1.0
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var wall_detector: RayCast2D = $WallDetector
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

var facing = 0


func _physics_process(delta):
	var input_velocity = get_input_velocity()
	velocity.y += get_gravity() * delta
	velocity.x = lerp(velocity.x, input_velocity * move_speed, movement_smoothing) 
	

	if is_on_floor():
		if input_velocity == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	
	if Input.is_action_just_pressed("jump"): 
		if ( is_on_floor() || !coyote_timer.is_stopped()):
			coyote_timer.stop()
			jump()
		
	if wall_detector.is_colliding() && !is_on_floor():
			if Input.is_action_just_pressed("jump"):
				wall_jump()
				

	var was_on_floor = is_on_floor()
	
	move_and_slide() 
	
	if !is_on_floor() && was_on_floor:
		coyote_timer.start()
		

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


func get_input_velocity() -> float:
	var horizontal = 0.0
	horizontal = Input.get_action_strength("right") - Input. get_action_strength("left")
	
	if horizontal < 0:
		animated_sprite.flip_h = true
		wall_detector.rotation_degrees = 90
		facing = horizontal 
	if horizontal > 0:
		animated_sprite.flip_h = false
		wall_detector.rotation_degrees = -90
		facing = horizontal
	

	return horizontal

func wall_jump():
	animated_sprite.play("jump_start")
	velocity.x = facing * wall_jump_knockback_velocity
	velocity.y = wall_jump_velocity

func jump():
	animated_sprite.play("jump_start")
	velocity.y = jump_velocity


