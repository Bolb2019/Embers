extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collide_with_areas = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.enabled = false
	
	if Input.is_action_just_pressed("Lmb"):
		self.enabled = true
		print("blam")
		if is_colliding():
			print("boom")
