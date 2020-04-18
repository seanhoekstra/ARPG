extends Node

export(int) var max_health = 1 setget set_maxhealth
onready var health = max_health setget set_health
onready var health_diff = 0
 
signal no_health

func set_health(value):
	if value > max_health:
		health = max_health
	else:
		health = value
	if health <= 0:
		emit_signal("no_health")
		

func set_maxhealth(value):
	health_diff = value - max_health
	max_health = value	
	if health == null:
		health = max_health
	else: 
		health += health_diff
