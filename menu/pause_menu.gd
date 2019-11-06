extends Node2D

var is_hide = true

func _process(delta):
	if is_hide == true:
		$pause.hide();
	else:
		$pause.show();
		
	var pos = get_node("../player").global_position
	var x = floor(pos.x / 160) * 160
	var y = floor(pos.y / 128) * 128
	global_position = Vector2(x,y)

func _input(event):
	
	if Input.is_action_just_pressed("pause") and is_hide == false:
		get_tree().paused = false
		is_hide = true
	elif Input.is_action_just_pressed("pause") and is_hide == true:
		get_tree().paused = true
		is_hide = false