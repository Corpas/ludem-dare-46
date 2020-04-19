extends Area2D

const GRAVITY = 50
var velocity = Vector2()

signal caught_bed
signal missed_bed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y += GRAVITY * delta
	position.y += velocity.y * delta

func _on_Bed_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("caught_bed")
		queue_free()
	if body.get_name() == "Floor":
		emit_signal("missed_bed")
		queue_free()
