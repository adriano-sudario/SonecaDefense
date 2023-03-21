extends "res://Scenes/Turrets/toy_turret.gd"

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "preparing_shoot":
		fire_projectile("bubble_projectile")
		get_node("Turret/AnimationPlayer").stop(true)

func update_facing_direction():
	if enemy == null:
		return
	
	if enemy.position.x < position.x and scale.x < 0:
		scale.x = abs(scale.x)
	elif enemy.position.x >= position.x and scale.x > 0:
		scale.x = -scale.x
	
	turret_node.rotation_degrees -= 180
#	projectile_spawn.rotation_degrees -= 180
