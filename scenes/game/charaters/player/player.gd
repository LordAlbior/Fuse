class_name Player
extends CharacterBody2D

@export var move_speed = 200.0
@export var jump_height: float = 50
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4
@export var dash_speed: float = 1000
@export var slide_gravity: float = 1000
@export_range(1, 100, 1) var extra_jumps: int = 0
@export_range(0.0, 1.0, 0.01) var movement_smoothing: float = 0.2

@export var wall_jump: bool = false

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var dash_timer: Timer = $DashTimer
@onready var wall_detector: RayCast2D = $WallDetector
@onready var gun_detector: RayCast2D = $GunDetector
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var gun_center: Marker2D = $GunCenter
@onready var gunpoint:Marker2D = $GunCenter/Gunpoint
@onready var gunpoint2:Marker2D = $GunCenter/Gunpoint2
@onready var gunpoint3:Marker2D = $GunCenter/Gunpoint3

	
var direction: float = 0.0

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func get_input_velocity() -> float:
	var horizontal = 0.0
	horizontal = Input.get_action_strength("right") - Input. get_action_strength("left")
	
	if horizontal < 0:
		animated_sprite.scale.x = horizontal
		wall_detector.scale.x = horizontal
		gun_detector.scale.x = horizontal
		gun_center.scale.x = horizontal
	if horizontal > 0:
		animated_sprite.scale.x = horizontal
		wall_detector.scale.x = horizontal
		gun_detector.scale.x = horizontal
		gun_center.scale.x = horizontal
		
	direction = horizontal
	return horizontal
