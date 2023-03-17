extends Node2D

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
	if data.projectile == "gun":
		fire_gun()
	elif data.projectile == "missile":
		fire_missile()
	
	enemy.on_hit(data.damage)
	await get_tree().create_timer(data.fire_rate).timeout
	fire_ready = true

func fire_gun():
	get_node("AnimationPlayer").play("fire")

func fire_missile():
	pass

func get_type():
	var script_path = get_script().get_path()
	var directories = script_path.split("/")
	return directories[directories.size() - 1].split(".")[0]

func turn():
	get_node("Turret").look_at(enemy.position)

func _on_range_body_entered(body):
	enemies.append(body.get_parent())

func _on_range_body_exited(body):
	enemies.erase(body.get_parent())
