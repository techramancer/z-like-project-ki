extends KinematicBody2D

#EXPORTS / CONSTANTS

export(int) var SPEED = 0
export(String) var TYPE = "PLAYER"
export(float) var MAXHEALTH = 1
export(float) var health = MAXHEALTH

#VARIABLES

var movedir = dir.center
var knockdir = dir.center
var spritedir = "down"
var player_death = 0
var hitstun = 0
var texture_default = null
var texture_hurt = null
var reset_key = 1
var iframe = 0
var flicker = true
var bomb_enabled = 1
var bomb_pickup = 0
var which_bomb
var motion
var bomb_pick

#FUNCTIONS

func _ready():
	randomize()
	if TYPE == "ENEMY":
		set_collision_mask_bit(1,1)
		set_physics_process(false)
	texture_default = $Sprite.texture
	texture_hurt = load($Sprite.texture.get_path().replace(".png","_hurt.png"))

func movement_loop():
#	var motion
	var nomotion = false
	
	if nomotion == false:
		if hitstun == 0 && TYPE == "ENEMY" && health <= 0:
			motion = Vector2(0,0)
			nomotion = 1
		elif hitstun == 0:
			motion = movedir.normalized() * SPEED
			nomotion = false
		elif hitstun != 0 && is_on_wall():
			motion = Vector2(0,0)
			nomotion = true
		elif hitstun != 0:
			motion = knockdir.normalized() * 125
			nomotion = false
		if TYPE == "ENEMY":
			move_and_slide(motion, dir.center)
	
	if TYPE == "PLAYER":
		move_and_slide(motion, dir.center)

func spritedir_loop():
	match movedir:
		dir.left:
			spritedir = "left"
		dir.right:
			spritedir = "right"
		dir.up:
			spritedir = "up"
		dir.down:
			spritedir = "down"

func anim_switch(animation):
	var newanim = str(animation,spritedir)
	if $anim.current_animation != newanim:
		$anim.play(newanim)
	
		
func damage_loop():
	health = min(MAXHEALTH, health)
	if hitstun > 0:
		hitstun -= 1
		$Sprite.texture = texture_hurt
	else:
		if TYPE == "PLAYER":
			$hitbox.monitoring = true
		$Sprite.texture = texture_default
		
	if iframe > 0 && TYPE == "PLAYER":
		iframe -= 1
		$hitbox.monitoring = false
		if flicker == true:
			$Sprite.visible = false
			flicker = false
		else:
			$Sprite.visible = true
			flicker = true
	for area in $hitbox.get_overlapping_areas():
		var body = area.get_parent()
		if hitstun == 0 and body.get("DAMAGE") != null and body.get("TYPE") != TYPE:
			health -= body.get("DAMAGE")
			hitstun = 10
			iframe = 50
			knockdir = global_transform.origin - body.global_transform.origin

func pickup_loop():
	for area in $pickbox.get_overlapping_areas():
		var body = area.get_parent()
		if body.name == "bomb":
			get_node("../hud/shift_sprite").frame = 1
			bomb_pickup = 1
			which_bomb = body
			bomb_pick = which_bomb.bomb_pick
		else:
			bomb_pickup = 0

func use_item(item):
	var newitem = item.instance()
	newitem.add_to_group(str(newitem.get_name(), self))
	add_child(newitem)
	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
		newitem.queue_free()
		
func drop_item(item,direction):
	var newitem = item.instance()
	newitem.global_position = global_position
	newitem.direction = direction
	newitem.add_to_group(str(newitem.get_name(), self))
	get_parent().add_child(newitem)
#	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
#		newitem.queue_free()
		
func projectile(item,direction):
	var newitem = item.instance()
	newitem.global_position = global_position
	newitem.direction = direction
	newitem.add_to_group(str(newitem.get_name(), self))
	get_parent().add_child(newitem)
#	if get_tree().get_nodes_in_group(str(newitem.get_name(), self)).size() > newitem.maxamount:
#		newitem.queue_free()
		
func instance_scene(scene):
	var new_scene = scene.instance()
	new_scene.global_position = global_position
	new_scene.z_index = 2
	get_parent().add_child(new_scene)