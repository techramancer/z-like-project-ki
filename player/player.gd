extends "res://engine/entity.gd"

var state = "default"
var death_anim = 0
var keys = 0
var money = 867
var bombs = 99
var arrows = 99
var sword = true
var shield = false
var direction = dir.down
var arrow_timer = 25
var arrow_enabled = 1
var roll_timer = 0
var push_anim = false

func _ready():
	set_collision_mask_bit(1,0)
	
func _process(delta):
	match $Sprite.frame:
		0,1:
			direction = dir.down
			$pickbox.position = Vector2(0,15)
		2,3:
			direction = dir.up
			$pickbox.position = Vector2(0,-13)
		4,5:
			direction = dir.right
			$pickbox.position = Vector2(12,1)
		6,7:
			direction = dir.left
			$pickbox.position = Vector2(-12,1)

func _physics_process(delta):
	match state:
		"default":
			state_default()
		"swing":
			state_swing()
		"death":
			state_death()
			
	keys = min(keys, 9)

func state_default():
	if arrow_timer > 0 && arrow_enabled == 0:
		arrow_timer -= 1
	elif arrow_timer == 0:
		arrow_enabled = 1
		arrow_timer = 25
	controls_loop()
	movement_loop()
	spritedir_loop()
	damage_loop()
	pickup_loop()
	check_shift()
	
	if Input.is_action_pressed("death"):
		health = 0
	
	if is_on_wall() and movedir != Vector2(0,0) and hitstun == 0:
		push_anim = true
		anim_switch("push")
	elif movedir != Vector2(0,0):
		push_anim = false
		anim_switch("walk")
	else:
		anim_switch("idle")
	if health <= 0 && death_anim == 0:
		hitstun = 0
		state = "death"
	wield()

func wield():
	if Input.is_action_just_pressed("x") && Input.is_action_just_pressed("z"):
		if get_node("../hud").x_key == "arrow" && get_node("../hud").z_key == "bomb" || get_node("../hud").z_key == "arrow" && get_node("../hud").x_key == "bomb":
			state = "default"
			bomb_arrow()
	elif Input.is_action_just_pressed("x"):
		if get_node("../hud").x_key == "sword":
			state = "default"
			use_item(preload("res://items/sword.tscn"))
		elif  get_node("../hud").x_key == "arrow":
			state = "default"
			arrow()
		elif get_node("../hud").x_key == "bomb":
			state = "default"
			bomb()
	elif Input.is_action_just_pressed("z"):
		if get_node("../hud").z_key == "sword":
			state = "default"
			use_item(preload("res://items/sword.tscn"))
		elif  get_node("../hud").z_key == "arrow":
			state = "default"
			arrow()
		elif get_node("../hud").z_key == "bomb":
			state = "default"
			bomb()
	elif Input.is_action_just_pressed("action"):
		for area in $pickbox.get_overlapping_areas():
			var body = area.get_parent()
			if bomb_enabled == 0 && body.name == "bomb":
				which_bomb.play_pickup()
			#roll action
			if get_node("../hud/shift_sprite").frame == 0 && body.name != "bomb":
				roll_timer = 75

func check_shift():
	for area in $pickbox.get_overlapping_areas():
		var body = area.get_parent()
		if body.name == "bomb" || bomb_pick == 1:
			get_node("../hud/shift_sprite").frame = 1
		else:
			if roll_timer > 0:
				roll_timer -= 1
				get_node("../hud/shift_sprite").frame = 4
			elif roll_timer == 0:
				get_node("../hud/shift_sprite").frame = 0
		

func arrow():
	if arrow_enabled == 1:
		if arrows > 0:
			projectile(preload("res://projectiles/arrow.tscn"),direction)
			arrow_enabled = 0
		arrows -= 1

func bomb():
	if bomb_enabled == 1:
		if bombs > 0:
			drop_item(preload("res://items/bombs.tscn"),direction)
			bomb_enabled = 0
		bombs -= 1
	if bomb_pickup == 1:
		if movedir != dir.center:
			which_bomb.play_toss()
			bomb_pick = which_bomb.bomb_pick
		else:
			which_bomb.play_pickup()
			bomb_pick = which_bomb.bomb_pick

func bomb_arrow():
	if bomb_enabled == 1 && arrow_enabled == 1:
		if bombs > 0 && arrows > 0:
			drop_item(preload("res://projectiles/bombarrow.tscn"),direction)
			bomb_enabled = 0
			arrow_enabled = 0
		bombs -= 1
		arrows -= 1

func state_swing():
	anim_switch("swing")
	movement_loop()
	damage_loop()
	movedir = dir.center

func state_death():
	while death_anim == 0:
		death_anim = 1
		$anim.play("deathanim")
	if Input.is_action_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_pressed("regen"):
		health = MAXHEALTH
	if health >= .5:
		state = "default"
		death_anim = 0
	
func controls_loop():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	movedir.x = -int(LEFT)+int(RIGHT)
	movedir.y = -int(UP)+int(DOWN)