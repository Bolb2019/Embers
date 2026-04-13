extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	genMap()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func genMap():
	position = $"../Player".position
	for i in range(-9, 10):
		for j in range(-5, 6):
			var Tile = Sprite2D.new()
			Tile.texture = preload("res://Level/Tile.png")
			Tile.position = Vector2(i*144, j*144)
			add_child(Tile)


func _on_player_property_list_changed() -> void:
	genMap()
