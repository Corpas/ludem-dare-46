extends RigidBody2D


const GRAVITY = 2.0
var velocity = Vector2()

signal touched_bomb

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	position.y += velocity.y * delta


func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("touched_bomb", self)
