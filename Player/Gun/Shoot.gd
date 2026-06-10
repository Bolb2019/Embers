extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collide_with_areas = true
	collide_with_bodies = true
	self.enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Lmb"):
		$"../GPUParticles2D".emitting = true
		if self.is_colliding():
			var body = self.get_collider()
			body.queue_free()
			GlobalBpm.kills += 1;
