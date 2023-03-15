extends AnimatedSprite2D

func _ready():
	play("destroy")

func _on_animation_finished():
	get_parent().queue_free()
