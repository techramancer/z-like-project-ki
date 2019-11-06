extends Node

signal scene_changed()

onready var animation_player = get_node("Fade2D/anim")
onready var black = get_node("Fade2D/Control/Black")

func change_scene(path, delay = 0.5):
	animation_player.play("default")
	yield(animation_player, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
#	print($"/root/fade".get_node("Fade2D").position)# = pos
	animation_player.play_backwards("default")
	yield(animation_player, "animation_finished")
	emit_signal("scene_changed")