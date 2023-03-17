extends Node2D

signal on_game_lost()

@onready var money_label = get_node("UI/HUD/InfoBar/HBoxContainer/Money")
@onready var ui_node = get_node("UI")

var map_node
var path_node

var is_placing_toy = false
var is_tile_avaiable = false
var toy_tile_position
var build_tile
var build_type

var current_wave = 0
var enemies_in_wave = 0
var base_health = 100
var money = 200

func _ready():
	map_node = get_node("QuietRoomMap")
	path_node = map_node.get_node("Path")
	money_label.text = str(money)
	
	for i in get_node("UI/HUD/BuildBar").get_children():
		var type = i.get_name().to_lower()
		var cost = GameData.toy[type].price
		i.get_node("CostLabel").text = str(cost)
		i.pressed.connect(initiate_build_mode.bind(type, cost))

func _process(_delta):
	if is_placing_toy:
		update_tower_preview()

func _unhandled_input(event):
	if !is_placing_toy:
		return
	
	if event.is_action_released("ui_cancel"):
		cancel_build_mode()
	
	if event.is_action_released("ui_accept"):
		verify_and_build()

func initiate_build_mode(type, cost):
	if cost > money:
		return
	
	if is_placing_toy:
		cancel_build_mode()
	
	build_type = type
	is_placing_toy = true
	ui_node.set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var tower_exclusion = map_node.get_node("TowerExclusion")
	var current_tile = tower_exclusion.local_to_map(mouse_position)
	var tile_position = tower_exclusion.map_to_local(current_tile)
	is_tile_avaiable = tower_exclusion.get_cell_source_id(0, current_tile) == -1

	if is_tile_avaiable:
		toy_tile_position = tile_position
		build_tile = current_tile

	ui_node.update_tower_preview(tile_position, is_tile_avaiable)

func start_next_wave():
	var wave_data = retrieve_wave_data()
	spawn_enemies(wave_data)

func retrieve_wave_data():
	var wave_data = [
		{"type": "ghost", "delay": .7},
		{"type": "ghost", "delay": .7},
		{"type": "ghost", "delay": .7},
		{"type": "ghost", "delay": .7},
		{"type": "ghost", "delay": .7},
		{"type": "ghost", "delay": .7}
	]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		var enemy = load("res://Scenes/Enemies/" + i.type + ".tscn").instantiate()
		enemy.base_damage.connect(on_base_damage)
		enemy.on_destroy.connect(on_enemy_destroyed)
		path_node.add_child(enemy, true)
		await get_tree().create_timer(i.delay).timeout

func cancel_build_mode():
	is_placing_toy = false
	is_tile_avaiable = false
	get_node("UI/TowerPreview").free()

func verify_and_build():
	if !is_tile_avaiable:
		return
	
	waste_money(GameData.toy[build_type].price)
	var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instantiate()
	new_tower.position = toy_tile_position
	new_tower.built = true
	map_node.get_node("Turrets").add_child(new_tower, true)
	map_node.get_node("TowerExclusion").set_cell(0, build_tile, 5, Vector2i(1, 0))
	cancel_build_mode()

func earn_money(amount):
	money += amount
	money_label.text = str(money)

func waste_money(amount):
	money -= amount
	money_label.text = str(money)

func on_base_damage(damage):
	base_health -= damage
	
	if base_health <= 0:
		emit_signal("on_game_lost")
	else:
		get_node("UI").update_health_bar(base_health)

func on_enemy_destroyed(enemy):
	earn_money(enemy.bounty)
