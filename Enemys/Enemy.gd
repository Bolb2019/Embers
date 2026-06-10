extends CharacterBody2D

const MAX_SPEED = 550.0
const ACCELERATION = 2000.0
const FRICTION = 1800.0
const MOVE_DISTANCE = 144.0
const MOVE_DURATION = 0.05
const GRID_SIZE = 144.0
var MOVE_DELAY = (float(60) / float(GlobalBpm.bpm)) * 2

var current_direction := Vector2.ZERO
var is_moving := false
var time = 0
var wait_time = 0
var target_position_grid: Vector2 = Vector2.ZERO

func _ready() -> void:
	global_position = snap_to_grid(global_position)

func _physics_process(delta: float) -> void:
	time += delta
	if is_moving:
		return

	var direction := Vector2.ZERO
	if abs($"../../Player".global_position.y - self.global_position.y) > abs($"../../Player".global_position.x - self.global_position.x):
		if ($"../../Player".global_position.y-144 > self.global_position.y): 
			direction = Vector2(0, 1)
		elif ($"../../Player".global_position.y+144 < self.global_position.y):
			direction = Vector2(0, -1)
	else:
		if ($"../../Player".global_position.x-144 > self.global_position.x):
			direction = Vector2(1, 0)
		elif ($"../../Player".global_position.x+144 < self.global_position.x):
			direction = Vector2(-1, 0)


	if direction != Vector2.ZERO and time > wait_time:
		var target_grid_pos = snap_to_grid(global_position + direction * MOVE_DISTANCE)
		if is_square_empty(target_grid_pos):
			target_position_grid = target_grid_pos
			wait_time = time + MOVE_DELAY
			_move_in_direction(direction)

	move_and_slide()

func _move_in_direction(direction: Vector2) -> void:
	is_moving = true
	var target_position = position + direction * MOVE_DISTANCE

	var stretch_scale: Vector2
	if direction.x != 0:
		stretch_scale = Vector2(1.3, 0.7)
	else:
		stretch_scale = Vector2(0.7, 1.3)

	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(self, "position", target_position, MOVE_DURATION)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property($Sprite2D, "scale", stretch_scale, MOVE_DURATION * 0.4)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property($Sprite2D, "scale", Vector2.ONE, MOVE_DURATION * 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.set_parallel(false)
	tween.chain().tween_callback(func():
		target_position_grid = Vector2.ZERO
		is_moving = false
	)
	
func snap_to_grid(pos: Vector2) -> Vector2:
	"""Round position to nearest grid square"""
	return Vector2(
		round(pos.x / GRID_SIZE) * GRID_SIZE,
		round(pos.y / GRID_SIZE) * GRID_SIZE
	)

func is_square_empty(grid_pos: Vector2) -> bool:
	"""Check if a grid square is empty (no player, no enemies, no incoming enemies)"""
	var spawner = get_parent()

	var player = $"../../Player"
	if snap_to_grid(player.global_position) == grid_pos:
		return false

	var enemies = spawner.get_children() if spawner else []
	for enemy in enemies:
		if enemy != self and enemy is CharacterBody2D:
			if snap_to_grid(enemy.global_position) == grid_pos:
				return false
			if enemy.has_meta("target_position_grid") or "target_position_grid" in enemy:
				if enemy.target_position_grid == grid_pos:
					return false
	
	return true
