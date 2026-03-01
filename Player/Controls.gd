extends CharacterBody2D

const MAX_SPEED = 550.0
const ACCELERATION = 2000.0
const FRICTION = 1800.0

var current_direction := Vector2.ZERO


func _physics_process(delta: float) -> void:
	var input_direction := Input.get_vector("Left", "Right", "Up", "Down")
	input_direction = input_direction.normalized()
	
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * MAX_SPEED, ACCELERATION * delta)
		current_direction = input_direction
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()
