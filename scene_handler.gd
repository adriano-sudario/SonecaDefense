extends Node

func _ready():
	on_new_game_pressed()
#	load_main_menu()

func load_main_menu():
	var menu = load("res://Scenes/UIScenes/main_menu.tscn").instantiate()
	menu.get_node("M/VB/NewGame").pressed.connect(on_new_game_pressed)
	menu.get_node("M/VB/Quit").pressed.connect(on_quit_pressed)
	add_child(menu)

func on_new_game_pressed():
	var menu_node = get_node_or_null("MainMenu")
	
	if menu_node != null:
		menu_node.queue_free()
	
	var game_scene = load("res://Scenes/MainScenes/gameplay_scene.tscn").instantiate()
	var map = load("res://Scenes/Maps/quiet_room_map.tscn").instantiate()
	game_scene.add_child(map)
	game_scene.on_game_lost.connect(go_to_main_menu)
	add_child(game_scene)

func on_quit_pressed():
	get_tree().quit()

func go_to_main_menu():
	get_node("GameplayScene").queue_free()
#	var main_menu = load("res://Scenes/UIScenes/main_menu.tscn").instantiate()
#	add_child(main_menu)
#	load_main_menu()
	get_tree().quit()
