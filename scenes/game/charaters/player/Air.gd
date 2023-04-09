# Air.gd
extends PlayerState

var jumps = 0
# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = player.jump_velocity
		player.animated_sprite.play("jump_start")
		jumps = msg["do_jump"]
	else:
		player.coyote_timer.start()
	

func physics_update(delta: float) -> void:
	# Horizontal movement.
	var input_velocity_x: float = player.get_input_velocity()
	
	player.velocity.y += player.get_gravity() * delta
	player.velocity.x = lerp(player.velocity.x, input_velocity_x * player.move_speed, player.movement_smoothing) 
	player.move_and_slide()



	# Landing.
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
	elif player.wall_detector.is_colliding() && \
	( Input.is_action_pressed("left") && player.wall_detector.scale.x < 0 || \
	Input.is_action_pressed("right") && player.wall_detector.scale.x > 0) &&\
	player.wall_jump:
		state_machine.transition_to("Wall")
			
	if Input.is_action_just_pressed("jump"):
		if !player.coyote_timer.is_stopped():
			state_machine.transition_to("Air", {do_jump = jumps})
		elif jumps >= 1:
			state_machine.transition_to("Air", {do_jump = jumps - 1})

	if Input.is_action_just_pressed("action_1"):
		state_machine.transition_to("Attack")
func exit() -> void:
		player.animated_sprite.play("jump_end")
