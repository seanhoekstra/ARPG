extends Area2D

var player = null

onready var collsion_shape_2d = $CollisionShape2D

func can_see_player():
	return player !=null

func _on_PlayerDetectionZone_body_entered(body):
	player = body

func _on_PlayerDetectionZone_body_exited(_body):
	player = null
