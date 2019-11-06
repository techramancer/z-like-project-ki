extends Node2D

export(bool) var disappears = false
export(int) var money = 0
export(String) var pickup_type = "item"
var exist = 90

var spawn = 15
var anim = 0
var drop = 1

func _process(delta):
	if spawn > 0:
		spawn -= 1
	exist()
		
func exist():
	if exist > 0:
		exist -= 1
	elif exist == 0:
		queue_free()

func _ready():
	connect("body_entered",self,"body_entered")
	connect("area_entered",self,"area_entered")
	#on_drop()

func on_drop():
	if drop == 1 && pickup_type == "key":
		$Sprite/anim.play("default")
		drop = 0
#
#func area_entered(area):
#	var area_parent = area.get_parent()
#	if area_parent.name == 'sword':
#		body_entered(area_parent.get_parent())
#
#func body_entered(body):
#	if spawn == 0 && pickup_type == "key" && body.name == "player" && body.get("keys") < 9:
#		body.keys += 1
#		queue_free()
#	elif pickup_type == "money" && body.name == "player":
#		body.money += money
#		if body.money > 999:
#			body.money = 999
#		queue_free()
#	elif pickup_type == "heart" && body.name == "player":
#		body.health += 1
#		if body.health >= body.MAXHEALTH:
#			body.health = body.MAXHEALTH
#		queue_free()