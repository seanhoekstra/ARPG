extends KinematicBody2D

var acceleration = 500
var max_speed = 140
var friction = 500
var velocity = Vector2.ZERO

enum {MOVE, ROLL, ATTACK}

var state = MOVE

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

#only play the animation when the game is active
func _ready():
	animation_tree.active = true
	

#It's hard to choose between process and physics process.
#For now we use physiscs_process because the godot examples prescribe it.
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)
	
	
	

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") -Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down")-Input.get_action_strength("ui_up")
	#to make sure the diagonal speed is the same as the straight movement we normalize the vector	
	input_vector = input_vector.normalized()
	
	# to compansate for lag we multiply by delta
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:		
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		animation_state.travel("Idle")
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")
	
func attack_animation_finished():
	state = MOVE
