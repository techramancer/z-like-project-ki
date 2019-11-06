extends Area2D

func _physics_process(delta):
	#check if entity is inside border while hitstun is not 0
	#set collision layer until hitstun is 0
	
	if hitstun != 0:
		set_collision_layer_bit(1,1)