extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

#state machine
enum{
	IDLE,
	WANDER,
	CHASE	
}

export var acceleration = 300
export var max_speed = 50
export var friction = 200

var knockback = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var state = IDLE
var velocity = Vector2.ZERO

onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox

func _ready():
		
	rng.randomize()
	var my_random_number = rng.randi_range(0, 5)
	if my_random_number == 0:
		$AnimatedSprite.animation = 'FlyBlue'
		stats.max_health = 4
		max_speed = 85
		acceleration = 420
		friction = 150 #more knockback to make hitting easier
		#adjusts all bats not just the blue one. We can make different bats expanding a bat class to fix this
		#found the "local to scene" option in the collisionshape (circleshape/resource), making different bats is still a good idea
		player_detection_zone.collision_shape_2d.shape.set_radius(200)
	elif my_random_number in [1,2]:
		$AnimatedSprite.animation = 'FlyGreen'
	else:		
		$AnimatedSprite.animation = 'Fly'

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				#player position - bat position = the vector difference between the 2
				#normalize the length so equalize the speed
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
				sprite.flip_h = velocity.x < 0	
			else:
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
	var enemy_death_effect = EnemyDeathEffect.instance()
	get_parent().add_child(enemy_death_effect)
	enemy_death_effect.global_position = global_position
