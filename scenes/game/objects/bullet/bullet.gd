class_name Bullet
extends Area2D

@onready var sparks_scene: PackedScene = preload("res://scenes/game/effects/bullet_sparks/bullet_collision_particles.tscn")
var direction: Vector2 = Vector2.RIGHT
var speed: float = 400


func _ready():
	body_entered.connect(on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(on_screen_exited)

func _process(delta):
	translate(direction.normalized() * speed * delta)

		


func on_body_entered(body: Node2D):
	#Do damage
	var sparks: GPUParticles2D = sparks_scene.instantiate()
	get_parent().add_child(sparks)
	sparks.global_position = global_position
	sparks.emitting = true
	queue_free()
	
	
func on_screen_exited():
	queue_free()

