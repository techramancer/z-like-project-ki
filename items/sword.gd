extends Node2D

var TYPE = null
const DAMAGE = .5

var maxamount = 1

func _ready():
	TYPE = get_parent().TYPE
	$anim_swing.connect("animation_finished",self,"destroy")
	$anim_swing.play(str("swing",get_parent().spritedir))
	if get_parent().has_method("state_swing"):
		get_parent().state = "swing"

func destroy(animation):
	if get_parent().has_method("state_swing"):
		get_parent().state = "default"
	queue_free()