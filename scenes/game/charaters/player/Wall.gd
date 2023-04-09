extends PlayerState


func enter(msg := {}) -> void:
	player.animated_sprite.play("idle")

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(delta: float) -> void:
	if player.wall_detector.is_colliding():
		player.velocity.y = player.slide_gravity * delta
		player.move_and_slide()	
	else:
		state_machine.transition_to("Air") 
	
	if player.is_on_floor():
		state_machine.transition_to("Idle") 
	
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = 0}) 
