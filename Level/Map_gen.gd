extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	genMap()

func _on_player_property_list_changed() -> void:
	genMap()

func genMap():
	# Remove all old tiles
	for child in get_children():
		child.queue_free()
	
	position = $"../Player".position
	for i in range(-9, 10):
		for j in range(-5, 6):
			var Tile = Sprite2D.new()
			Tile.position = Vector2(i*144, j*144)
			Tile.texture = preload("res://Level/Tile.png")
			add_child(Tile)
