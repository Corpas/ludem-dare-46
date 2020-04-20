extends RigidBody2D

onready var impact_player = $ImpactPlayer

const GRAVITY = 2.0
var velocity = Vector2()
var bomb_timer = 0.0
const BOMB_LIFE = 24.0

signal touched_bomb
signal remove_bomb

# Called when the node enters the scene tree for the first time.
func _process(delta):
	bomb_timer += delta
	if bomb_timer > BOMB_LIFE:
		emit_signal("remove_bomb", self)
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	position.y += velocity.y * delta


func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		emit_signal("touched_bomb", self)
	elif body.get_name() == "TileMap":
		impact_player.play()
