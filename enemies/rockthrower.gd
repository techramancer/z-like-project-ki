extends "res://engine/entity.gd"

export (float) var DAMAGE = 0.5
export (String) var spc_drop = "null"

var state = "default"
var movetimer_length = 15
var movetimer = 0
var deathtimer = 60
var death_scene = 0
var rock_enabled = 0
var rock_timer = 45
var rand_rock = 0

func _ready():
	$anim.play("walkdown")
	movedir = dir.rand()

func _physics_process(delta):
	if rand_rock != 4 && health > 0:
		rand_rock = randi() % 150
	elif rand_rock == 4 && health > 0:
		state_rock()
	match state:
		"default":
			state_default()
		"rock":
			state_rock()

func state_default():
	if rock_enabled == 0:
		movement_loop()
	damage_loop()
	
	if health > 0:
		spritedir_loop()
		if movetimer > 0:
			anim_switch("walk")
			movetimer -= 1
		elif movetimer == 0 || is_on_wall():
			movedir = dir.rand()
			movetimer = movetimer_length
	elif health <= 0:
		$hitbox.set_collision_layer_bit(0,0)
		$hitbox.set_collision_mask_bit(0,0)
		anim_switch("idle")
		if death_scene == 0 && hitstun == 0:
			death_scene = 1
			instance_scene(preload("res://enemies/enemy_death.tscn"))
		if deathtimer > 0:
			deathtimer -= 1
		elif deathtimer == 0:
			var drop = randi() % 100
			if spc_drop == "key":
				instance_scene(preload("res://pickups/key.tscn"))
			else:
				if drop >= 50 && drop <= 69:
					instance_scene(preload("res://pickups/heart.tscn"))
				elif drop >= 0 && drop <= 99:
					instance_scene(preload("res://pickups/g_money.tscn"))
				elif drop >=95 && drop <= 99:
					instance_scene(preload("res://pickups/b_money.tscn"))
#				elif drop >= 99 && drop <= 103:
#					instance_scene(preload("res://pickups/r_money.tscn"))
#				elif drop >= 104 && drop <=105:
#					instance_scene(preload("res://pickups/y_money.tscn"))
			queue_free()

func state_rock():
	if rock_enabled == 0:
		projectile(preload("res://projectiles/rock.tscn"),movedir)
		rock_enabled = 1
	elif rock_enabled == 1:
		if rock_timer > 0:
			rock_timer -= 1
		elif rock_timer == 0:
			rock_enabled = 0
			rand_rock = 0
			state = "default"
			rock_timer == 45