extends GPUParticles2D



func _ready():
	$Timer.timeout.connect(on_timeout)
	$Timer.start()


func on_timeout():
	queue_free()
