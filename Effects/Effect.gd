extends AnimatedSprite

func _ready():
	frame = 0 # in case someone screws with teh editor
	connect("animation_finished", self, "_on_animation_finished")
	#below fixes warning but keeps an int in memory. hogging up this memory seems unnecesary so far
	#var error = connect("animation_finished", self, "_on_animation_finished")
	#if error != 0:
	#	print(error)
	play("Animate") 

func _on_animation_finished():
	queue_free()

