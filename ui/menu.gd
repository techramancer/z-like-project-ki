extends CanvasLayer

#EXPORTS / CONSTANTS
const SCREEN_SIZE = Vector2(160,128)
const HEART_ROW_SIZE = 7
const HEART_OFFSET = 7

#VARIABLES 
var menu = 0
var is_menu = 0
var pause_timer = 60
onready var menu_pos = $menu.global_transform[2].y
onready var player = get_node("../player")
onready var cursor_pos = Vector2($menu.position.x - 62,$menu.position.y - 39)
var x_key = "bomb"
var z_key = "arrow"
var temp_key = ""
var slot_frame
var objects = ["sword","bomb","arrow","wings","empty"]
var save_menu_pos = Vector2(0,0)
#onready var x_icon_pos = Vector2($menu.position.x - 62,$menu.position.y - 39)
#var y_icon_pos = Vector2(0,0)
var c_toggle = 0

#CURSOR VARIABLES
var cursor_c1
var cursor_c2
var cursor_r1
var cursor_r2
var cursor_r3
var cursor_r4
var cursor_r5

#MENU OBJECTS
var slot0 = objects[0]
var slot1 = objects[4]
var slot2 = objects[4]
var slot3 = objects[4]
var slot4 = objects[4]
var slot5 = objects[4]
var slot6 = objects[4]
var slot7 = objects[4]
var slot8 = objects[4]
var slot9 = objects[4]
var slot_temp

#FUNCTIONS

func _ready():
	for i in player.MAXHEALTH:
		var new_heart = Sprite.new()
		new_heart.texture = $hearts.texture
		new_heart.hframes = $hearts.hframes
		$hearts.add_child(new_heart)

func _process(delta):
	hud_loop()
	menu_loop()
	cursor_loop()
	inventory_loop()

func _input(event):
	if Input.is_action_just_pressed("pause") && menu == 0:
		menu = 1
		$cursor.position = cursor_pos
		get_tree().paused = true

	elif Input.is_action_just_pressed("pause") && menu == 1:
		menu = 2

		
func get_grid_pos(pos):
	pos.y -= 14
	var x = floor(pos.x / SCREEN_SIZE.x)
	var y = floor(pos.y / SCREEN_SIZE.y)
	return Vector2(x,y)

func menu_loop():
	if menu == 1:
		if is_menu == 0:
			$anim.play("default")
		is_menu = 1
		if pause_timer > 0:
			pause_timer -= 1
		if pause_timer == 0:
			pause_timer = 60
			$cursor.show()
	if menu == 2:
		if is_menu == 1:
			$anim.play_backwards("default")
		is_menu = 0
		$cursor.hide()
		if pause_timer > 0:
			pause_timer -= 1
		if pause_timer == 0:
			get_tree().paused = false
			pause_timer = 60
			menu = 0

func cursor_loop():
	cursor_c1 = $menu.position.x - 62;cursor_c2 = $menu.position.x - 35;cursor_r1 = $menu.position.y - 39
	cursor_r2 = $menu.position.y - 20;cursor_r3 = $menu.position.y - 1;cursor_r4 = $menu.position.y + 18;cursor_r5 = $menu.position.y + 37
	cursor_pos = $cursor.position
	if menu == 1:
		c_toggle = 1
		if Input.is_action_just_pressed("ui_up"):
			if $cursor.position.y != cursor_r1:
				$cursor.position.y -= 19
		if Input.is_action_just_pressed("ui_down"):
			if $cursor.position.y != cursor_r5:
				$cursor.position.y += 19
		if Input.is_action_just_pressed("ui_right"):
			if $cursor.position.x != cursor_c2:
				$cursor.position.x += 27
		if Input.is_action_just_pressed("ui_left"):
			if $cursor.position.x != cursor_c1:
				$cursor.position.x -= 27
		if Input.is_action_just_pressed("quit") && menu == 1 && !$anim.is_playing():
			save_menu_pos = $cursor.position
			$cursor.hide()
			$cursor.position = Vector2(0,0)
			menu = 4
			c_toggle = 0
			$quit.visible = true
			$qcursor.visible = true

	if menu == 4:
		if Input.is_action_just_pressed("ui_right"):
			if $qcursor.position.x != ($menu.position.x + 4):
				$qcursor.position.x += 25
		if Input.is_action_just_pressed("ui_left"):
			if $qcursor.position.x != ($menu.position.y - 13):
				$qcursor.position.x -= 25
		if Input.is_action_just_pressed("x") && $qcursor.position.x == ($menu.position.y - 13):
			fade.change_scene("res://engine/TitleScreen.tscn",Vector2(0,0))
		elif Input.is_action_just_pressed("x") && $qcursor.position.x == ($menu.position.y + 12) || Input.is_action_just_pressed("z"):
			menu = 1
			$cursor.position = save_menu_pos
			$cursor.show()
			$quit.visible = false
			$qcursor.visible = false

func inventory_loop():
	
	if Input.is_action_just_pressed("x") && menu == 1:
		var slot = ""
		temp_key = x_key
		slot = determine_slot($cursor.position)
		match_slot(slot,"x")
	elif Input.is_action_just_pressed("z") && menu == 1:
		var slot = ""
		temp_key = z_key
		slot = determine_slot($cursor.position)
		match_slot(slot,"z")

func determine_slot(pos):
	if pos == Vector2(cursor_c1,cursor_r1):
		return "slot0"
	elif pos == Vector2(cursor_c2,cursor_r1):
		return "slot1"
	elif pos == Vector2(cursor_c1,cursor_r2):
		return "slot2"
	elif pos == Vector2(cursor_c2,cursor_r2):
		return "slot3"
	elif pos == Vector2(cursor_c1,cursor_r3):
		return "slot4"
	elif pos == Vector2(cursor_c2,cursor_r3):
		return "slot5"
	elif pos == Vector2(cursor_c1,cursor_r4):
		return "slot6"
	elif pos == Vector2(cursor_c2,cursor_r4):
		return "slot7"
	elif pos == Vector2(cursor_c1,cursor_r5):
		return "slot8"
	elif pos == Vector2(cursor_c2,cursor_r5):
		return "slot9"

func match_slot(slot,key):
	match key:
		"x":
			slot_frame = $x_sprite.frame
			match slot:
				"slot0":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot0.frame
					x_key = slot0
					$menu/slot0.frame = slot_frame
					slot0 = slot_temp
					slot_temp = null
				"slot1":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot1.frame
					x_key = slot1
					$menu/slot1.frame = slot_frame
					slot1 = slot_temp
					slot_temp = null
				"slot2":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot2.frame
					x_key = slot2
					$menu/slot2.frame = slot_frame
					slot2 = slot_temp
					slot_temp = null
				"slot3":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot3.frame
					x_key = slot3
					$menu/slot3.frame = slot_frame
					slot3 = slot_temp
					slot_temp = null
				"slot4":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot4.frame
					x_key = slot4
					$menu/slot4.frame = slot_frame
					slot4 = slot_temp
					slot_temp = null
				"slot5":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot5.frame
					x_key = slot5
					$menu/slot5.frame = slot_frame
					slot5 = slot_temp
					slot_temp = null
				"slot6":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot6.frame
					x_key = slot6
					$menu/slot6.frame = slot_frame
					slot6 = slot_temp
					slot_temp = null
				"slot7":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot7.frame
					x_key = slot7
					$menu/slot7.frame = slot_frame
					slot7 = slot_temp
					slot_temp = null
				"slot8":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot8.frame
					x_key = slot8
					$menu/slot8.frame = slot_frame
					slot8 = slot_temp
					slot_temp = null
				"slot9":
					slot_temp = x_key
					$x_sprite.frame = $menu/slot9.frame
					x_key = slot9
					$menu/slot9.frame = slot_frame
					slot9 = slot_temp
					slot_temp = null
		"z":
			slot_frame = $z_sprite.frame
			match slot:
				"slot0":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot0.frame
					z_key = slot0
					$menu/slot0.frame = slot_frame
					slot0 = slot_temp
					slot_temp = null
				"slot1":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot1.frame
					z_key = slot1
					$menu/slot1.frame = slot_frame
					slot1 = slot_temp
					slot_temp = null
				"slot2":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot2.frame
					z_key = slot2
					$menu/slot2.frame = slot_frame
					slot2 = slot_temp
					slot_temp = null
				"slot3":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot3.frame
					z_key = slot3
					$menu/slot3.frame = slot_frame
					slot3 = slot_temp
					slot_temp = null
				"slot4":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot4.frame
					z_key = slot4
					$menu/slot4.frame = slot_frame
					slot4 = slot_temp
					slot_temp = null
				"slot5":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot5.frame
					z_key = slot5
					$menu/slot5.frame = slot_frame
					slot5 = slot_temp
					slot_temp = null
				"slot6":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot6.frame
					z_key = slot6
					$menu/slot6.frame = slot_frame
					slot6 = slot_temp
					slot_temp = null
				"slot7":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot7.frame
					z_key = slot7
					$menu/slot7.frame = slot_frame
					slot7 = slot_temp
					slot_temp = null
				"slot8":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot8.frame
					z_key = slot8
					$menu/slot8.frame = slot_frame
					slot8 = slot_temp
					slot_temp = null
				"slot9":
					slot_temp = z_key
					$z_sprite.frame = $menu/slot9.frame
					z_key = slot9
					$menu/slot9.frame = slot_frame
					slot9 = slot_temp
					slot_temp = null


func hud_loop():
	if opt.key_highlight == 1 && menu == 0:
		if Input.is_action_pressed("x"):
			$x_hl.show()
		else:
		#elif !Input.is_action_pressed("x"):
			$x_hl.hide()
		if Input.is_action_pressed("z"):
			$z_hl.show()
		else:
		#elif !Input.is_action_pressed("z"):
			$z_hl.hide()
	
	for heart in $hearts.get_children():
		var index = heart.get_index()
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = (index / HEART_ROW_SIZE) * HEART_OFFSET
		heart.position = Vector2(x,y)
		
		var last_heart = floor(player.health)
		if index > last_heart:
			heart.frame = 0
		if index == last_heart:
			heart.frame = (player.health - last_heart) * 4
		if index < last_heart:
			heart.frame = 4
	
	$menu/keys.frame = player.keys % 10
	
	$money3.frame = player.money % 10
	$money2.frame = (player.money % 100 - $money3.frame) / 10
	$money1.frame = (player.money % 1000 - $money3.frame - $money2.frame) / 100
	
	$arrow2.frame = player.arrows % 10
	$arrow1.frame = (player.arrows % 100 - $arrow2.frame) / 10
	
	$bomb2.frame = player.bombs % 10
	$bomb1.frame = (player.bombs % 100 - $bomb2.frame) / 10