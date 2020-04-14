extends AnimatedSprite

func _ready():
	frame = 0 # in case someone screws with teh editor
	connect("animation_finished", self, "_on_animation_finished")
	play("Animate") 

func _on_animation_finished():
	queue_free()
