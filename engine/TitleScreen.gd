extends Node2D

var cursor_pos = Vector2(62,78)
var menu_swap = 0
onready var kh_toggle = opt.key_highlight
var kh_cursor = 0
var cursor = 1

func _ready():
	opt.load_settings()
	$"/root/fade".get_node("Fade2D").position = Vector2(0,0)

func _process(delta):
	kh_toggle = opt.key_highlight
	$cursor.position = cursor_pos
	cursor_loop()


#func options_loop():
#	if kh_toggle.visible == 1:
#		opt._settings = {
#			"debug": {
#				"key_highlight": 1
#			}
#		}
#	elif kh_toggle.visible == 0:
#		opt._settings = {
#			"debug": {
#				"key_highlight": 0
#			}
#		}

func cursor_loop():
	if menu_swap == 0:
		if cursor_pos == Vector2(62,106):
			if Input.is_action_just_pressed("ui_up"):
				cursor_pos = Vector2(62,92)
			elif Input.is_action_just_pressed("x"):
				get_tree().quit()
		elif cursor_pos == Vector2(62,92):
			if Input.is_action_just_pressed("ui_up"):
				cursor_pos = Vector2(62,78)
			elif Input.is_action_just_pressed("ui_down"):
				cursor_pos = Vector2(62,106)
			elif Input.is_action_just_pressed("x"):
				$options.show()
				if kh_toggle == 1:
					$kh_toggle.show()
				$cursor.hide()
				cursor = 0
				cursor_pos = Vector2(54,101)
				$kh_cursor.show()
				kh_cursor = 1
				menu_swap = 1
		elif cursor_pos == Vector2(62,78):
			if Input.is_action_just_pressed("ui_down"):
				cursor_pos = Vector2(62,92)
			elif Input.is_action_just_pressed("x"):
				get_tree().paused = false
				fade.change_scene("res://areas/map_001.tscn")
	elif menu_swap == 1:
		if kh_cursor == 1:
			if Input.is_action_just_pressed("x"):
				if opt.key_highlight == 0:
					opt.key_highlight = 1
					$kh_toggle.show()
				elif opt.key_highlight == 1:
					opt.key_highlight = 0
					$kh_toggle.hide()
				opt.save_settings()
#				pass
			elif Input.is_action_just_pressed("ui_down"):
				kh_cursor = 0
				$kh_cursor.hide()
				cursor = 1
				$cursor.show()
		elif cursor == 1 && cursor_pos == Vector2(54,101):
			if Input.is_action_just_pressed("x"):
				$options.hide()
				$kh_toggle.hide()
				cursor_pos = Vector2(62,92)
				menu_swap = 0
			elif Input.is_action_just_pressed("ui_up"):
				cursor = 0
				$cursor.hide()
				kh_cursor = 1
				$kh_cursor.show()
	
#	if Input.is_action_just_pressed("ui_up") && cursor_pos == Vector2(62,100):
#		cursor_pos = Vector2(62,84)
#	elif Input.is_action_just_pressed("ui_down") && cursor_pos == Vector2(62,84):
#		cursor_pos = Vector2(62,100)
		