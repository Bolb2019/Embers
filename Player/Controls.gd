extends CharacterBody2D

const MAX_SPEED = 550.0
const ACCELERATION = 2000.0
const FRICTION = 1800.0
const MOVE_DISTANCE = 144.0
const MOVE_DURATION = 0.05
const GRID_SIZE = 144.0

var current_direction := Vector2.ZERO
var is_moving := false

func _physics_process(delta: float) -> void:
	
	if is_moving or !GlobalBpm.on_beat:
		return

	var direction := Vector2.ZERO

	if Input.is_action_just_pressed("Down"):
		notify_property_list_changed()
		direction = Vector2(0, 1)
	elif Input.is_action_just_pressed("Up"):
		notify_property_list_changed()
		direction = Vector2(0, -1)
	elif Input.is_action_just_pressed("Right"):
		notify_property_list_changed()
		direction = Vector2(1, 0)
	elif Input.is_action_just_pressed("Left"):
		notify_property_list_changed()
		direction = Vector2(-1, 0)

	if direction != Vector2.ZERO:
		var target_grid_pos = snap_to_grid(global_position + direction * MOVE_DISTANCE)
		if is_square_empty(target_grid_pos):
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
	tween.chain().tween_callback(func(): is_moving = false)

func snap_to_grid(pos: Vector2) -> Vector2:
	return Vector2(
		round(pos.x / GRID_SIZE) * GRID_SIZE,
		round(pos.y / GRID_SIZE) * GRID_SIZE
	)

func is_square_empty(grid_pos: Vector2) -> bool:
	var enemy_spawner = $"../Enemies"
	if enemy_spawner:
		for enemy in enemy_spawner.get_children():
			if snap_to_grid(enemy.global_position) == grid_pos:
				return false
	
	return true
