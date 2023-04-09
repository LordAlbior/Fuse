class_name DashGhost
extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	create_tween().tween_property(self, "modulate:a", 0, 0.5) \
	.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT).finished.connect(on_tween_finished)


func on_tween_finished():
	queue_free()
