extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $"../../../../IK Targets/target".position.x > 0:
		$Sprite2D.flip_v = false
	else:
		$Sprite2D.flip_v = true
