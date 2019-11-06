extends Area2D

func _ready():
	connect("body_entered",self,"body_entered")

func body_entered(body):
	if body.name == "player":
		body.health += 1
		if body.health >= body.MAXHEALTH:
			body.health = body.MAXHEALTH
		queue_free()