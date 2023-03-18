extends Node2D

var speed = 350
#var direction_angle = 0
#var direction
var damage = 0
var enemy

func _ready():
	var tween = get_tree().create_tween()
	var sprite = get_node("Sprite2D")
	sprite.scale = Vector2(0, 0)
	tween.tween_property(sprite, "scale", Vector2(1, 1), .05)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	get_node("AnimationPlayer").play("flying")
#	direction = Vector2.RIGHT.rotated(direction_angle)
	pass

func _process(delta):
	var toward_position = position.move_toward(enemy.position, speed * delta)
	position.x = move_toward(toward_position.x, 0, delta)
	position.y = move_toward(toward_position.y, 0, delta)

func _on_body_entered(body):
	if not body.is_in_group("enemies"):
		return
	
	var enemy = body.get_parent()
	enemy.on_hit(damage)
	enemy.apply_slow(enemy.speed * .5, 1.5)
	queue_free()
