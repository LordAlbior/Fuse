extends PlayerState

enum WeaponType {SINGLE, SHOTGUN}

@export var weapon_type: WeaponType = WeaponType.SHOTGUN

#@onready var explosion: PackedScene = preload("res://scenes/game/effects/bullet_sparks/bullet_collision_particles.tscn") 
@onready var bullet_scene: PackedScene = preload("res://scenes/game/objects/bullet/bullet.tscn")	

func enter(msg := {}) -> void:
	player.animated_sprite.play("shoot")
	player.animated_sprite.animation_finished.connect(on_animation_finished)
	shoot()


func physics_update(delta: float) -> void:
	var input_velocity_x: float = player.get_input_velocity()
	
	player.velocity.y += player.get_gravity() * delta
	player.velocity.x = lerp(player.velocity.x, input_velocity_x * player.move_speed, player.movement_smoothing) 
	player.move_and_slide()


func exit() -> void:
	player.animated_sprite.animation_finished.disconnect(on_animation_finished)


func on_animation_finished():
	state_machine.transition_to("Idle")


func shoot():
	# if player.gun_detector.is_colliding():
	#	var expl: GPUParticles2D = explosion.instantiate()
	#	add_child(expl)
	#	expl.emitting = true
	#	expl.position = player.gun_detector.get_collision_point()
	match weapon_type:
		WeaponType.SINGLE:
			var bullet = bullet_scene.instantiate() as Bullet
			bullet.direction = (player.gunpoint.global_position - player.gun_center.global_position ).normalized()
			bullet.global_position = player.gunpoint.global_position
			bullet.speed = 400
			print(bullet.global_position)
			get_tree().get_root().add_child(bullet)
		WeaponType.SHOTGUN:
			var bullet = bullet_scene.instantiate() as Bullet
			bullet.direction = (player.gunpoint.global_position - player.gun_center.global_position ).normalized()
			bullet.global_position = player.gunpoint.global_position
			bullet.speed = 300
			print(bullet.global_position)
			get_tree().get_root().add_child(bullet)
			
			var bullet2 = bullet_scene.instantiate() as Bullet
			bullet2.direction = (player.gunpoint2.global_position - player.gun_center.global_position ).normalized()
			bullet2.global_position = player.gunpoint2.global_position
			bullet2.speed = 300
			print(bullet2.global_position)
			get_tree().get_root().add_child(bullet2)
			
			var bullet3 = bullet_scene.instantiate() as Bullet
			bullet3.direction = (player.gunpoint3.global_position - player.gun_center.global_position ).normalized()
			bullet3.global_position = player.gunpoint3.global_position
			bullet3.speed = 300
			print(bullet3.global_position)
			get_tree().get_root().add_child(bullet3)
	
	
	

func on_hidden():
	print("Hidden")

		
