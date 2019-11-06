extends CanvasLayer

var is_hide = true

func _process(delta):
	if is_hide == true:
		layer = -1000
	else:
		layer = 1000

func _input(event):
	if Input.is_action_just_pressed("pause") and is_hide == false:
		get_tree().paused = false
		is_hide = true
	elif Input.is_action_just_pressed("pause") and is_hide == true:
		get_tree().paused = true
		is_hide = false
	if Input.is_action_just_pressed("quit") && is_hide == false:
		get_tree().quit()