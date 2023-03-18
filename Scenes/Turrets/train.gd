extends "res://Scenes/Turrets/toy_turret.gd"

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "preparing_shoot":
		fire_projectile("pillow_projectile")
		get_node("Turret/AnimationPlayer").stop(true)
