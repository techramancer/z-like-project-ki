extends KinematicBody2D

var TYPE = "PLAYER"
const DAMAGE = 1
const SPEED = 120

#var maxamount = 3
var object = "bombarrow"
var motion
var timer = 5
var z_timer = 10
var direction
var anim_timer = 35
var destroy_wall = 0

func _ready():
	$CollisionShape2D2.disabled = 1
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
	if timer > 0:
		timer -= 1
	else:
		$CollisionShape2D2.disabled = 0
	if is_on_wall():
		$Sprite.hide()
		$anim.play("explo")
		if anim_timer > 0:
			anim_timer -= 1
		elif anim_timer == 0:
			get_node("../player").bomb_enabled = 1
			get_node("../player").arrow_enabled = 1
			queue_free()
	else:
		motion = direction.normalized() * SPEED
		move_and_slide(motion, dir.center)

	for area in $area.get_overlapping_areas():
		var body = area.get_parent()
		if body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			queue_free()
