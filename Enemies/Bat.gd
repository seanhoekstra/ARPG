extends KinematicBody2D

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
	queue_free()
