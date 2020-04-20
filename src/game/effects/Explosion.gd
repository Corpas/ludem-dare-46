extends Node2D

onready var audio_player = $AudioPlayer
onready var anim_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_animation():
	print(anim_player)
	anim_player.play("explosion")

func is_animation_playing():
	return anim_player.is_playing()

func play_audio():
	audio_player.play()
