extends Node2D

#@onready var game_play_node = get_node("/root/SceneHandler/GameplayScene")
@onready var game_play_node = get_tree().current_scene.get_node("GameplayScene")
@onready var turret_node = get_node("Turret")
@onready var projectile_spawn = turret_node.get_node("ProjectileSpawn")

var enemies = []
var built = false
var fire_ready = true
var enemy
var data

func _ready():
	if !built:
		return
	
	data = GameData.toy[get_type()]
	var tower_range = data.range
	var shape = get_node("Range/CollisionShape2D").get_shape()
	shape.radius = .5 * tower_range

func _physics_process(_delta):
	if !built:
		return
	
	if enemies.size() > 0:
		select_enemy()
		turn()
		
		if fire_ready:
			fire()
	else:
		enemy = null

func _process(_delta):
	update_facing_direction()

func update_facing_direction():
	if enemy == null:
		return
	
	if enemy.position.x < position.x and scale.x > 0:
		scale.x = -scale.x
	elif enemy.position.x >= position.x and scale.x < 0:
		scale.x = abs(scale.x)
	
func select_enemy():
	var enemies_progress = []
	
	for i in enemies:
		enemies_progress.append(i.progress)
	
	var further_progress = enemies_progress.max()
	var enemy_index = enemies_progress.find(further_progress)
	enemy = enemies[enemy_index]

func fire():
	fire_ready = false
	turret_node.get_node("AnimationPlayer").play("preparing_shoot")
	await get_tree().create_timer(data.fire_rate).timeout
	fire_ready = true

func fire_projectile(projectile_name):
	turret_node.get_node("AnimationPlayer").play("preparing_shoot")
	var projectile = load("res://Scenes/Projectiles/" + projectile_name + ".tscn").instantiate()
	projectile.position = projectile_spawn.global_position
	projectile.damage = data.damage
#	projectile.direction_angle = projectile.position.direction_to(enemy.position).angle()
	projectile.enemy = enemy
	game_play_node.map_node.add_child(projectile)

func get_type():
	var script_path = get_script().get_path()
	var directories = script_path.split("/")
	return directories[directories.size() - 1].split(".")[0]

func turn():
	turret_node.look_at(enemy.position)

func _on_range_body_entered(body):
	if not body.is_in_group("enemies"):
		return
	
	enemies.append(body.get_parent())

func _on_range_body_exited(body):
	enemies.erase(body.get_parent())
