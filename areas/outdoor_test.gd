extends Node

var on_load = 0
var t = Timer.new()

func _process(delta):
	$Fade/anim.play_backwards("default")
	t.set_wait_time(.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()