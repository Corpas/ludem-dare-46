extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 200.0
export var walk_speed: float = 200.0

export var jump_velocity: float = 170.0

export var run_modifier: float = 75.0

var velocity = Vector2()
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite


# Called when the node enters the scene tree for the first time.
# func _ready():
#	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = 0
		velocity.y -= jump_velocity
		if velocity.x < 0:
			sprite.set_flip_h(true)
		elif velocity.x > 0:
			sprite.set_flip_h(false)
		
		animationPlayer.play("jump")
	elif Input.is_action_pressed("ui_left"):
		sprite.set_flip_h(false)
		var speed = walk_speed
		if Input.is_action_pressed("run_modify"):
			speed += run_modifier
		velocity.x = -speed
		animationPlayer.play("walk_left")
	elif Input.is_action_pressed("ui_right"):
		sprite.set_flip_h(false)
		var speed = walk_speed
		if Input.is_action_pressed("run_modify"):
			speed += run_modifier
		velocity.x = speed
		animationPlayer.play("walk_right")
	elif is_on_floor():
		sprite.set_flip_h(false)
		velocity.x = 0
		animationPlayer.play("idle")
	
	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.
	
	# The second parameter of "move_and_slide" is the normal pointing up.
	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
	move_and_slide(velocity, Vector2(0, -1))
