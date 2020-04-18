extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 50
var velocity = Vector2()
signal caught_food
signal missed_food

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += GRAVITY * delta
	position.y += velocity.y * delta


func _on_Food_body_entered(body):
	print(body.get_name())
	if body.get_name() == "Player":
		emit_signal("caught_food")
	if body.get_name() == "Floor":
		emit_signal("missed_food")
	
	queue_free()
