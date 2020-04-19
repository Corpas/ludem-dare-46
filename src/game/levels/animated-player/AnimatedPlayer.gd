extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var happy_face = preload("res://assets/player-happy.png")
var angry_face = preload("res://assets/player-angry.png")
var worried_face = preload("res://assets/player-worried.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	texture = happy_face

func _set_happy_face():
	texture = happy_face

func _set_angry_face():
	texture = angry_face
	
func _set_worried_face():
	texture = worried_face

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

