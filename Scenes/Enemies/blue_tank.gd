extends PathFollow2D

signal base_damage(damage)
signal on_destroy(enemy)

var speed = 150
var hp = 300
var is_destroyed = false
var attack_damage = 21
var bounty = 50

@onready var health_bar = get_node("HealthBar")
@onready var impact_marker = get_node("Impact")
var projectile_impact = load("res://Scenes/SupportScenes/projectile_impact.tscn")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	health_bar.top_level = true

func _physics_process(delta):
	if progress_ratio == 1:
		emit_signal("base_damage", attack_damage)
		queue_free()
	
	if is_destroyed:
		return
	
	move(delta)

func move(delta):
	set_progress(get_progress () + speed * delta)
	health_bar.position = position - Vector2(30, 30)

func on_hit(damage):
	if is_destroyed:
		return
	
	impact()
	hp -= damage
	health_bar.value = hp
	
	if hp <= 0:
		destroy()

func impact():
	randomize()
	var x = randi_range(-15, 15)
	randomize()
	var y = randi_range(-15, 15)
	var impact_location = Vector2(x, y)
	var new_impact = projectile_impact.instantiate()
	new_impact.position = impact_location
	impact_marker.add_child(new_impact)

func destroy():
#	get_node("/root/SceneHandler/GameScene").earn_money(bounty)
	emit_signal("on_destroy", self)
	is_destroyed = true
	health_bar.queue_free()
	get_node("CharacterBody2D").queue_free()
	var destroy_animation = load("res://Scenes/SupportScenes/destroy_animation.tscn").instantiate()
	add_child(destroy_animation)
