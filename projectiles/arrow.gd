extends KinematicBody2D

var TYPE = "PLAYER"
const DAMAGE = .5
const SPEED = 120

#var maxamount = 3
var object = "arrow"
var motion
var timer = 40
var z_timer = 10
var direction
var anim_timer = 35

func _ready():
	if direction == dir.up:
		$Sprite.rotation_degrees = 0
		z_index = -1
		if z_timer > 0:
			z_timer -= 1
	elif direction == dir.down:
		$Sprite.rotation_degrees = 180
		global_position = global_position + Vector2(-1,6)
	elif direction == dir.left:
		$Sprite.rotation_degrees = 270
		global_position = global_position + Vector2(-8,2)
	elif direction == dir.right:
		$Sprite.rotation_degrees = 90
		global_position = global_position + Vector2(7,2)
		
func _process(delta):
	if !(is_on_wall()):
		motion = direction.normalized() * SPEED
		move_and_slide(motion, dir.center)
	#get_parent().state = "default"
	if timer == 0 || is_on_wall():
#		instance_object(preload("res://tiles/arrow_ground.tscn"))
		match direction:
			dir.down:
				$anim.play("ricochet_down")
			dir.up:
				$anim.play("ricochet_up")
			dir.left:
				$anim.play("ricochet_left")
			dir.right:
				$anim.play("ricochet_right")
		if anim_timer > 0:
			anim_timer -= 1
		else:
			queue_free()
	if timer > 0:
		timer -= 1
	
	for area in $area.get_overlapping_areas():
		var body = area.get_parent()
		if body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			queue_free()
		