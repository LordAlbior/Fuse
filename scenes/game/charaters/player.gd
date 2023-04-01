extends CharacterBody2D

@export var move_speed = 200.0
@export var jump_height: float = 50
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4
@export var extra_jump: int = 1

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var coyote_timer: Timer = $CoyoteTimer

var jump_count = 0

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	velocity.x = get_input_velocity() * move_speed
	
	if Input.is_action_just_pressed("jump") and ( is_on_floor() || !coyote_timer.is_stopped()):
		coyote_timer.stop()
		jump()
	
	var was_on_floor = is_on_floor()
	
	move_and_slide() 
	
	if !is_on_floor() && was_on_floor:
		coyote_timer.start()

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	velocity.y = jump_velocity

func get_input_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("left"):
		horizontal -= 1.0
	if Input.is_action_pressed("right"):
		horizontal += 1.0
	
	return horizontal
