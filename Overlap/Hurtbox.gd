extends Area2D

export(bool) var  show_hit = true

const hit_effect = preload("res://Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area):
	if show_hit:
		var effect = hit_effect.instance()
		var main = get_tree().current_scene
		main.add_child(effect)
		#vector offset can also be done in the hiteffect
		#maybe the vector here can be based on the enemy offset
		effect.global_position = global_position - Vector2(0,8)
