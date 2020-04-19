extends KinematicBody2D


#state machine
enum{
	IDLE,
	WANDER,
	CHASE,
	ATTACK	
}

export var acceleration = 320
export var max_speed = 70
export var friction = 200

var knockback = Vector2.ZERO
var state = IDLE
var velocity = Vector2.ZERO

onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox


func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			sprite.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			sprite.play("Run")
			var player = player_detection_zone.player
			if player != null:
				#player position - bat position = the vector difference between the 2
				#normalize the length so equalize the speed
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
				sprite.flip_h = velocity.x < 0	
			else:							
				#if sprite.animation == "Attack" && sprite.frame == sprite.frames.get_frame_count("Attack")-1:
				#sprite.play("Attack")	
				state = IDLE	
	velocity = move_and_slide(velocity)
		
func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * area.knockback_power
	hurtbox.create_hit_effect()
	
	
func _on_Stats_no_health():
	#wait 0.2 second before clearing the enemy
	var t = Timer.new()
	t.set_wait_time(0.2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	
	queue_free()

#to check if the attack animation is finished, does sent a ton of signals, kinda ugly
func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.
