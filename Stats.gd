extends Node

export(int) var max_health = 1 setget set_maxhealth
var health = max_health setget set_health
 
signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value):
	if value > max_health:
		health = max_health
	else:
		health = value
	if health <= 0:
		emit_signal("no_health")
	emit_signal("health_changed", health)
		

func set_maxhealth(value):
	var health_diff = 0
	health_diff = value - max_health
	max_health = value	
	self.health += health_diff
	emit_signal("max_health_changed", max_health)
