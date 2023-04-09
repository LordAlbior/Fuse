# Run.gd
extends PlayerState


func enter(msg := {}) -> void:
	player.animated_sprite.play("run")

func physics_update(delta: float) -> void:

	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	var input_velocity_x: float = player.get_input_velocity()
	
	player.velocity.x = lerp(player.velocity.x, input_velocity_x * player.move_speed, player.movement_smoothing) 
	player.move_and_slide()

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Air", {do_jump = player.extra_jumps})
	elif Input.is_action_just_pressed("action_1"):
		state_machine.transition_to("Attack")
	elif is_equal_approx(input_velocity_x, 0.0):
		state_machine.transition_to("Idle")
	elif Input.is_action_just_pressed("action_2"):
		state_machine.transition_to("Dash")
 



