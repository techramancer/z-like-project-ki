extends "res://pickups/pickup.gd"

export(int) var money = 1

#export (int) var money = 1
#
#func _ready():
#	connect("body_entered",self,"body_entered")
#
#func body_entered(body):
#	if body.name == "player" && body.get("money") < 999:
#		body.money += money
#		queue_free()