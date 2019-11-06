extends KinematicBody2D

var TYPE = "PLAYER"
var DAMAGE = .5

var object = "bomb"
var maxamount = 1
var bomb_timer = 125
var direction
var bomb_pick = 0
var p_direction
var bomb_pos
var throw_timer = 0
var pickup_timer = 50

func _ready():
	
	DAMAGE = 0
	$sprExplo.hide()
	if direction == dir.up:
		z_index -= 1
		global_position.y = global_position.y - 7
	elif direction == dir.down:
		global_position.y = global_position.y + 13
	elif direction == dir.left:
		global_position = global_position - Vector2(12,-4)
	elif direction == dir.right:
		global_position = global_position + Vector2(12,4)

func _process(delta):
	p_direction = get_node("../player").direction
	if bomb_pick == 1 && get_node("../player").push_anim == false:
		move_and_slide(get_node("../player").motion, dir.center)
#		get_node("../player").bomb_pickup = 1
#		get_node("../player").bomb_enabled = 0
	
	if (bomb_timer % 4) == 0 && bomb_timer <= 90:
		if $sprBomb.frame == 0:
			$sprBomb.frame = 1
		elif $sprBomb.frame == 1:
			$sprBomb.frame = 0
	if bomb_timer == 35:
		bomb_pick = 2
		DAMAGE = .5
		$sprBomb.hide()
		$sprExplo.show()
		$anim.play("explo")
	if bomb_timer > 0:
		bomb_timer -= 1
	elif bomb_timer == 0:
		get_node("../player").bomb_enabled = 1
		bomb_pick = 0
		queue_free()
	for area in $area.get_overlapping_areas():
		var body = area.get_parent()
	if throw_timer > 0:
		throw_timer -= 1
	else:
		$CollisionShape2D.disabled = false
	if pickup_timer > 0 && bomb_pick == 1:
		pickup_timer -= 1
	elif pickup_timer == 0:
		$CollisionShape2D.disabled = true
		if is_instance_valid(get_node("../cracked_wall/CollisionShape2D")):
			get_node("../cracked_wall/CollisionShape2D").disabled = false

func play_pickup():
	match p_direction:
		dir.up:
			if bomb_pick == 0:
				$CollisionShape2D.disabled = true
				if is_instance_valid(get_node("../cracked_wall/CollisionShape2D")):
					get_node("../cracked_wall/CollisionShape2D").disabled = true
				$anim.play("pickup_up")
				bomb_pick = 1
			elif bomb_pick == 1:
				z_index = 0
				global_position = get_node("../player/pickbox").global_position - Vector2(0,-7)
				$anim.play_backwards("pickup_up")
				bomb_pick = 0
				$CollisionShape2D.disabled = false
		dir.down:
			if bomb_pick == 0:
				$anim.play("pickup_down")
				bomb_pick = 1
				$CollisionShape2D.disabled = true
			elif bomb_pick == 1:
				global_position = get_node("../player/pickbox").global_position - Vector2(0,2)
				$anim.play_backwards("pickup_down")
				bomb_pick = 0
				$CollisionShape2D.disabled = false
		dir.left:
			if bomb_pick == 0:
				$anim.play("pickup_left")
				bomb_pick = 1
				$CollisionShape2D.disabled = true
			elif bomb_pick == 1:
				global_position = get_node("../player/pickbox").global_position - Vector2(0,-3)
				$anim.play_backwards("pickup_left")
				bomb_pick = 0
				$CollisionShape2D.disabled = false
		dir.right:
			if bomb_pick == 0:
				$anim.play("pickup_right")
				bomb_pick = 1
				$CollisionShape2D.disabled = true
			elif bomb_pick == 1:
				global_position = get_node("../player/pickbox").global_position + Vector2(0,3)
				$anim.play_backwards("pickup_right")
				bomb_pick = 0
				$CollisionShape2D.disabled = false

func play_toss():
	match p_direction:
#		dir.up:
#			if bomb_pick == 1:
#				z_index = 0
#				global_position = get_node("../player/pickbox").global_position - Vector2(0,-7)
#				$anim.play_backwards("pickup_up")
#				bomb_pick = 0
#				$CollisionShape2D.disabled = false
		dir.down:
			if bomb_pick == 1:
				DAMAGE = .5
				global_position = get_node("../player/pickbox").global_position - Vector2(0,18)
				$anim.play("throw_down")
				bomb_pick = 0
				throw_timer = 15
				#$CollisionShape2D.disabled = false
#		dir.left:
#			if bomb_pick == 1:
#				global_position = get_node("../player/pickbox").global_position - Vector2(0,-3)
#				$anim.play_backwards("pickup_left")
#				bomb_pick = 0
#				$CollisionShape2D.disabled = false
#		dir.right:
#			if bomb_pick == 1:
#				global_position = get_node("../player/pickbox").global_position + Vector2(0,3)
#				$anim.play_backwards("pickup_right")
#				bomb_pick = 0
#				$CollisionShape2D.disabled = false