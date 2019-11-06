extends KinematicBody2D

var TYPE = null
const DAMAGE = .5
const SPEED = 60

var maxamount = 1
var motion
var rock_timer = 180
var direction

func _ready():
	TYPE = "ENEMY"
#	$anim.connect("animation_finished",self,"destroy")
	$anim.play("default")

func _process(delta):
	if direction == dir.up:
		z_index = -1
	motion = direction.normalized() * SPEED
	move_and_slide(motion, dir.center)
#	get_parent().state = "default"
	if rock_timer > 0:
		rock_timer -= 1
	elif rock_timer == 0:
		queue_free()
	for area in $area.get_overlapping_areas():
		var body = area.get_parent()
		if body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			queue_free()
	
#func destroy(animation):
#	if get_parent().has_method("state_swing"):
#		get_parent().state = "default"
#	queue_free()