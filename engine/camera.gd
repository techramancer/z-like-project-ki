extends Camera2D

const SCREEN_SIZE = Vector2(160,128)
const HUD_THICKNESS = 16
var grid_pos = Vector2(0,0)
onready var node = get_node("../player")
var next_screen = 0

func _ready():
	$area.connect("body_entered",self,"body_entered")
	$area.connect("body_exited",self,"body_exited")
	$area.connect("area_exited",self,"area_exited")

func _process(delta):
	var player_grid_pos = get_grid_pos(node.global_position)
	var next_glob_pos = player_grid_pos * SCREEN_SIZE
	pause_enemies()
	if global_position != next_glob_pos:
		next_screen = 1
		if global_position.x < next_glob_pos.x:
			global_position.x += 160 / 15
		elif global_position.x > next_glob_pos.x:
			global_position.x -= 160 / 15
		else:
			global_position.x = next_glob_pos.x

		if global_position.y < next_glob_pos.y:
			global_position.y += 128 / 15
		elif global_position.y > next_glob_pos.y:
			global_position.y -= 128 / 15
		else:
			global_position.y = next_glob_pos.y
	else:
		next_screen = 0
#		if global_position.y < next_glob_pos.y:
#			if (global_position.y + scy / sct) >= next_glob_pos.y:
#				global_position.y = next_glob_pos.y
#			else:
#				global_position.y += scy / sct
#		elif global_position.y > next_glob_pos.y:
#			if (global_position.y + scy / sct) <= next_glob_pos.y:
#				global_position.y = next_glob_pos.y
#			else:
#				global_position.y -= scy / sct
#		else:
#			global_position.y = next_glob_pos.y
	grid_pos = player_grid_pos
	
	if node.get("hitstun") != 0:
		node.set_collision_mask_bit(1,1)
	else:
		node.set_collision_mask_bit(1,0)
	
func get_grid_pos(pos):
	pos.y -= HUD_THICKNESS
	var x = floor(pos.x / SCREEN_SIZE.x)
	var y = floor(pos.y / SCREEN_SIZE.y)
	return Vector2(x,y)
	
func get_enemies():
	var enemies = []
	for body in $area.get_overlapping_bodies():
		if body.get("TYPE") == "ENEMY" && enemies.find(body) == -1:
			enemies.append(body)
	return enemies.size()

func pause_enemies():
	for body in $area.get_overlapping_bodies():
		if body.get("TYPE") == "ENEMY" && next_screen == 1:
			body.set_physics_process(false)
		elif body.get("TYPE") == "ENEMY" && next_screen == 0:
			body.set_physics_process(true)
		elif body.get("object") == "bomb" && next_screen == 1:
			get_node("../player").bomb_enabled = 1
			body.queue_free()

func body_entered(body): #player enters room
	if body.get("TYPE") == "ENEMY": #if enemies exist in room
		body.set_physics_process(true) #enable enemy movement
func body_exited(body):
	if body.get("TYPE") == "ENEMY":
		body.set_physics_process(false)
	if body.get("object") == "arrow" || body.get("object") == "bombarrow":
		get_node("../player").bomb_enabled = 1
		get_node("../player").arrow_enabled = 1
		body.queue_free()
func area_exited(area):
	if area.get("disappears") == true:
		area.queue_free()
		
func get_max(first,second):
	if first > second:
		return first
	elif second > first:
		return second