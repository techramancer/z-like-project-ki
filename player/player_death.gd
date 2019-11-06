extends Node

var reset_key = 0

func _ready():
	if get_parent().has_method("state_death"):
		get_parent().state = "death"