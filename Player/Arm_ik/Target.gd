extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# keep this node at the mouse so that `global_position` represents the aim point
	global_position = get_global_mouse_position()

	var player = get_node("../..")
	var player_pos: Vector2 = player.global_position

	# compute direction from player to the aim point
	var to_aim: Vector2 = global_position - player_pos
	var dist: float = to_aim.length()
	if dist > 0.001:
		var dir: Vector2 = to_aim / dist
		# place the lookat point 50px further along the same ray
		var lookat_pos: Vector2 = player_pos + dir * (dist + 50)
		$target_lookat.global_position = lookat_pos
		$target_lookat.rotation = dir.angle()
	else:
		# fallback if player and aim coincide
		$target_lookat.global_position = player_pos + Vector2(50, 0)
		$target_lookat.rotation = 0.0
