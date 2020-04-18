extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 200.0
const WALK_SPEED = 200.0

var velocity = Vector2()
var animationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animationPlayer = get_node("AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		animationPlayer.play("walk_left")
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
		animationPlayer.play("walk_right")
	else:
		velocity.x = 0
		animationPlayer.play("idle")
	
	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.
	
	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))
