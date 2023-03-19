extends GPUParticles2D

var range_radius = 50
var enemies_hit = []
var damage = 0

func _ready():
	emitting = true
	var tween = get_tree().create_tween()
	var shape = get_node("Area/CollisionShape2D").shape
	shape.radius = 0
	tween.tween_property(shape, "radius", range_radius, .5)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	await get_tree().create_timer(1).timeout
	get_node("Area").queue_free()
	await get_tree().create_timer(.5).timeout
	queue_free()


func _on_area_body_entered(body):
	var target = body.get_parent()
	
	if enemies_hit.find(target) != -1:
		return
	
	enemies_hit.append(target)
	target.on_hit(damage)
	target.apply_slow(target.speed * .5, 1.5)
