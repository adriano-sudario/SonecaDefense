extends CanvasLayer

@onready var hp_bar = get_node("HUD/InfoBar/HBoxContainer/TextureProgressBar")

func set_tower_preview(toy_id, mouse_position):
	var drag_tower = load("res://Scenes/Turrets/" + toy_id + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	
	var range_texture = Sprite2D.new()
	range_texture.position = Vector2(0, 0)
	var scaling = GameData.toy[toy_id].range / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/UI/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("AD54FF3C")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)

func update_tower_preview(position, can_build):
	get_node("TowerPreview").position = position
	var drag_tower = get_node("TowerPreview/DragTower")
	var range_texture = get_node("TowerPreview/Sprite2D")
	
	if !can_build and drag_tower.modulate.a != 0.5:
		drag_tower.modulate.a = 0.3
		range_texture.modulate = Color("FF5C5C")
	elif can_build and drag_tower.modulate.a != 1:
		drag_tower.modulate.a = 1
		range_texture.modulate = Color("AD54FF3C")

func update_health_bar(base_health):
	var tween = get_tree().create_tween()
	tween.tween_property(hp_bar, "value", base_health, .1)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	if base_health >= 60:
		hp_bar.set_tint_progress("4EFF15")
	elif base_health < 60 and base_health >= 25:
		hp_bar.set_tint_progress("E1BE32")
	else:
		hp_bar.set_tint_progress("E11E1E")

func _on_play_pause_pressed():
	var parent = get_parent()
	
	if parent.is_placing_toy:
		parent.cancel_build_mode()
	
	if parent.current_wave == 0:
		parent.start_next_wave()
		return
	
	var tree = get_tree()
	tree.paused = !tree.paused


func _on_speed_pressed():
	if get_parent().is_placing_toy:
		get_parent().cancel_build_mode()
	
	if Engine.get_time_scale() == 2:
		Engine.set_time_scale(1)
	else:
		Engine.set_time_scale(2)
