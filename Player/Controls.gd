extends CharacterBody2D

const MAX_SPEED = 550.0
const ACCELERATION = 2000.0
const FRICTION = 1800.0
const MOVE_DISTANCE = 144.0
const MOVE_DURATION = 0.05  # seconds to complete the movement

var current_direction := Vector2.ZERO
var is_moving := false

func _physics_process(delta: float) -> void:
	if is_moving:
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
		_move_in_direction(direction)

	move_and_slide()

func _move_in_direction(direction: Vector2) -> void:
	is_moving = true
	var target_position = position + direction * MOVE_DISTANCE

	# Determine stretch axis: stretch along movement, squash perpendicular
	var stretch_scale: Vector2
	if direction.x != 0:
		stretch_scale = Vector2(1.3, 0.7)  # moving horizontally
	else:
		stretch_scale = Vector2(0.7, 1.3)  # moving vertically

	var tween = create_tween()
	tween.set_parallel(true)

	# Move to target
	tween.tween_property(self, "position", target_position, MOVE_DURATION)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Stretch at start, then return to normal
	tween.tween_property(self, "scale", stretch_scale, MOVE_DURATION * 0.4)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(self, "scale", Vector2.ONE, MOVE_DURATION * 0.6)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.set_parallel(false)
	tween.chain().tween_callback(func(): is_moving = false)
