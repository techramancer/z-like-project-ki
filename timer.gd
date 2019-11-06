extends Node

var t = Timer.new()

func wait(time):
	t.set_wait_time(time)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	if t.time_left == 0:
		t.queue_free()