extends KinematicBody2D

export var acceleration = 500
export var max_speed = 140
export var friction = 600
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
export var roll_speed = 1.5

enum {MOVE, ROLL, ATTACK}

var state = MOVE
var stats = PlayerStats

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
#only play the animation when the game is active

func _ready():
	stats.connect("no_health",self,"queue_free")
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector

#It's hard to choose between process and physics process.
#For now we use physiscs_process because the godot examples prescribe it.
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") -Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	#to make sure the diagonal speed is the same as the straight movement we normalize the vector	
	input_vector = input_vector.normalized()
	
	# to compansate for lag we multiply by delta
	# we only updte the direction of the roll while we're moving. To avoid rolling in place.
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:		
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animation_state.travel("Idle")
		
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
			
	if Input.is_action_just_pressed("roll"):
		state = ROLL	
	
func roll_state(_delta):	
	#if uncommented here and in roll finished this whould make the player invincible while rolling.
	#can also be a variable vor an item or something
	#hurtbox.invincible = true
	velocity = roll_vector * max_speed * roll_speed
	animation_state.travel('Roll')
	move()	
	
func attack_state(_delta):
	animation_state.travel("Attack")
	
func move():
	velocity = move_and_slide(velocity)	
	
func roll_animation_finished():
	#reducing the leftover speed after rolling to normal speed * 0.7
	velocity = roll_vector * max_speed * 0.7
	#hurtbox.invincible = false
	state = MOVE	
	
func attack_animation_finished():
	state = MOVE

#can change 1 to area.damage
func _on_Hurtbox_area_entered(_area):
	stats.health -=1
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
