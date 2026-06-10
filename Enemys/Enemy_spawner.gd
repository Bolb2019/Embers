extends Node2D

const ENEMY_SPAWN = 50 #High numbers = higher spawns
const MAX_ENEMIES = 20

var time = 0
var wait_time = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	if time > wait_time:
		wait_time += 3
		genEnemies()

func genEnemies():
	if get_child_count() >= MAX_ENEMIES:
		return
	
	var player_pos = $"../Player".global_position 
	for i in range(-9, 10):
		for j in range(-5, 6):
			if get_child_count() >= MAX_ENEMIES:
				return
			
			if randi() % ENEMY_SPAWN == 0 and (i < -1 or i > 1) and (j < -1 or j > 1):
				var Enemy = preload("res://Enemys/Enemy.tscn").instantiate()
				add_child(Enemy)
				Enemy.global_position = player_pos + Vector2(i * 144, j * 144)  # ✅ offset from player
