extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

var knockback = Vector2.ZERO
var friction = 200
var rng = RandomNumberGenerator.new()

onready var stats = $Stats

func _ready():
		
	rng.randomize()
	var my_random_number = rng.randi_range(0, 5)
	if my_random_number == 0:
		$AnimatedSprite.animation = 'FlyBlue'
		stats.max_health = 4
	elif my_random_number in [1,2]:
		$AnimatedSprite.animation = 'FlyGreen'
	else:		
		$AnimatedSprite.animation = 'Fly'

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,friction * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * area.knockback_power
	
	
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
