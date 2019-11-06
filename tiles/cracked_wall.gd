extends StaticBody2D

var TYPE = "wall"
var initiate_timer = 0
var b_timer = 15
var bomb_pick
var bomb

export(bool) var outside = 0

func _ready():
	$area.connect("body_entered",self,"body_entered")

func _process(delta):
	if initiate_timer == 1 && is_instance_valid(bomb):
		if bomb.object == "bomb":
			if bomb.get_node("sprExplo").visible == true && outside == false && bomb_pick == 0:
				$Sprite.frame = 1
				$CollisionShape2D.disabled = 1
			elif bomb.get_node("sprExplo").visible == true && outside == true && bomb_pick == 0:
				queue_free()
		elif bomb.object == "bombarrow":
			if b_timer > 0:
				b_timer -= 1
			else:
				if bomb.get_node("sprExplo").visible == true && outside == false:
					$Sprite.frame = 1
					$CollisionShape2D.disabled = 1
				elif bomb.get_node("sprExplo").visible == true && outside == true:
					queue_free()

func body_entered(body):
	if body.name == "bomb":
		bomb_pick = body.bomb_pick
		bomb = body
	elif body.name == "bombarrow":
		bomb = body
	if body.name == "bomb" && initiate_timer == 0:
			initiate_timer = 1
	elif body.name == "bombarrow" && initiate_timer == 0:
		initiate_timer = 1