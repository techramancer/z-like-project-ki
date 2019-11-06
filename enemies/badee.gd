extends "res://engine/entity.gd"

export (float) var DAMAGE = 0.5
export (String) var spc_drop = "null"

var movetimer_length = 15
var movetimer = 0
var deathtimer = 60
var death_scene = 0
var spc_key = preload("res://pickups/key.tscn")

func _ready():
	$anim.play("default")
	movedir = dir.rand()

func _physics_process(delta):
	movement_loop()
	damage_loop()
#	drop_loop()
#	if movetimer > 0:
#		movetimer -= 1
#	elif movetimer == 0 || is_on_wall():
#		movedir = dir.rand()
#		movetimer = movetimer_length

	if health > 0:
		if movetimer > 0:
			anim_switch("default")
			movetimer -= 1
		elif movetimer == 0 || is_on_wall():
			movedir = dir.rand()
			movetimer = movetimer_length
	elif health <= 0:
		z_index = 0
		$hitbox.set_collision_layer_bit(0,0)
		$hitbox.set_collision_mask_bit(0,0)
		anim_switch("idle")
		if death_scene == 0 && hitstun == 0:
			death_scene = 1
			instance_scene(preload("res://enemies/enemy_death.tscn"))
		if deathtimer > 0:
			deathtimer -= 1
		elif deathtimer == 0:
			drop_loop()
			queue_free()

func drop_loop():
	if TYPE == "ENEMY" and health <= 0:
			var drop = randi() % 115
			if spc_drop == "key":
				instance_item(spc_key)
			else:
				if drop >= 69 && drop <= 73:
					instance_scene(preload("res://pickups/arrow5.tscn"))
				elif drop >= 54 && drop <= 68:
					instance_scene(preload("res://pickups/arrow1.tscn"))
				elif drop >= 34 && drop <= 53:
					instance_scene(preload("res://pickups/heart.tscn"))
				elif drop >= 14 && drop <= 33:
					instance_scene(preload("res://pickups/g_money.tscn"))
				elif drop >=6 && drop <= 13:
					instance_scene(preload("res://pickups/b_money.tscn"))
				elif drop >= 2 && drop <= 5:
					instance_scene(preload("res://pickups/r_money.tscn"))
				elif drop >= 0 && drop <=1:
					instance_scene(preload("res://pickups/y_money.tscn"))
#			instance_scene(preload("res://enemies/enemy_death.tscn"))
			queue_free()

func instance_item(scene):
	var new_scene = scene.instance()
	new_scene.global_position = $Sprite.global_position
	new_scene.z_index = 0
	get_parent().add_child(new_scene)