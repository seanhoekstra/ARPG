extends Area2D

const hit_effect = preload("res://Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended


func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
	
func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
		
	
func create_hit_effect():	
	var effect = hit_effect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	#vector offset can also be done in the hiteffect
	#maybe the vector here can be based on the enemy offset
	effect.global_position = global_position - Vector2(0,8)


func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibility_started():
	set_deferred("monitoring",false)


func _on_Hurtbox_invincibility_ended():
	set_deferred("monitoring",true)
