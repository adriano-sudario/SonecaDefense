extends Node

var tower_data = {
	"gun_t_1": {
		"damage": 20,
		"fire_rate": .2,
		"range": 350,
		"price": 100,
		"projectile": "gun"
	},
	"gun_t_2": {
		"damage": 30,
		"fire_rate": .1,
		"range": 400,
		"price": 250,
		"projectile": "gun"
	},
	"missile_t_1": {
		"damage": 250,
		"fire_rate": 2,
		"range": 550,
		"price": 150,
		"projectile": "missile"
	}
}

var toy = {
	"train": {
		"damage": 35,
		"fire_rate": 2,
		"range": 350,
		"price": 100,
		"projectile": "train_projectile"
	},
	"bear": {
		"damage": 10,
		"fire_rate": .2,
		"range": 300,
		"price": 100,
		"projectile": "train_projectile"
	}
}

var enemy = {
	"ghost": {
		"speed": 150,
		"health_points": 100,
		"damage": 20,
		"bounty": 50
	}
}
