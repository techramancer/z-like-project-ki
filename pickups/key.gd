extends "res://pickups/pickup.gd"

func _ready():
	if spawn > 0:
		spawn -= 1

func body_entered(body):
	if spawn == 0:
		if body.name == "player" && body.get("keys") < 9:
			body.keys += 1
			queue_free()