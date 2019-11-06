extends TileMap

func _ready():
	var size = get_cell_size()
	var offset = size / 2
	var name = "water_anim"
	var node = load(str("res://tiles/",name,".tscn")).instance()
	node.global_position = 5 * size + offset
	get_parent().call_deferred("add_child",node)
	queue_free()