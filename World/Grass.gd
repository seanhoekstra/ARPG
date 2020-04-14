extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	#add the effect as a child of the world
	#var world = get_tree().current_scene
	#world.add_child(grass_effect)
	#refactored for now
	
	
	var grass_effect = GrassEffect.instance()
	get_parent().add_child(grass_effect)
	grass_effect.global_position = global_position		
	


func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	#remove the grass
	queue_free()
