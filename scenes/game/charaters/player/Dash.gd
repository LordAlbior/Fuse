extends PlayerState

var ghost_scene: PackedScene = preload("res://scenes/game/effects/afterimage/dash_ghost.tscn")
var input_velocity_x: float = 0


func enter(msg := {}) -> void:
	player.dash_timer.start()


func physics_update(delta: float) -> void:

	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	if player.dash_timer.is_stopped():
		state_machine.transition_to("Idle")
	else:
		instance_ghost()	
		player.velocity.x = player.direction * player.dash_speed
		player.move_and_slide()


	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = player.extra_jumps})


func instance_ghost():
	var ghost: AnimatedSprite2D = ghost_scene.instantiate()
	player.get_parent().add_child(ghost)
	
	ghost.global_position = player.animated_sprite.global_position
	ghost.sprite_frames = player.animated_sprite.sprite_frames
	ghost.flip_h = player.animated_sprite.flip_h
	ghost.flip_v = player.animated_sprite.flip_v
	ghost.frame = player.animated_sprite.frame
