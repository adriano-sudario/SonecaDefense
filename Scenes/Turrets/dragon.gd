extends "res://Scenes/Turrets/toy_turret.gd"

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "preparing_shoot":
		fire_projectile("fire_projectile")
		get_node("Turret/AnimationPlayer").stop(true)

func update_facing_direction():
	super.update_facing_direction()
	
	if enemy == null:
		return
	
	if turret_node.rotation_degrees < -30 or (turret_node.rotation_degrees < 330 and turret_node.rotation_degrees > 180):
		turret_node.rotation_degrees = -30
	elif turret_node.rotation_degrees > 30:
		turret_node.rotation_degrees = 30
