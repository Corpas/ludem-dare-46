extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var pizza_scene = load("res://src/drops/hunger/Pizza.tscn")
onready var cherry_scene = load("res://src/drops/hunger/Cherry.tscn")
onready var banana_scene = load("res://src/drops/hunger/Banana.tscn")
onready var random = RandomNumberGenerator.new()
onready var screen_size = get_viewport().get_visible_rect().size
onready var hunger_meter = $Overlay/Control/HungerMeter
onready var player = $Player
onready var player_face = $AnimatedPlayer/Sprite
onready var collect_player = $CollectPlayer
onready var argh_player = $ArghPlayer

var food
var init = true

signal level_end

# Called when the node enters the scene tree for the first time.
func _ready():
	player.get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
# warning-ignore:unused_argument
func _process(delta):
	var hunger_value = hunger_meter.get_value()
	if(hunger_value < 30):
		player_face._set_worried_face()
	if (hunger_value == 0 and init == false) or hunger_value == 100:
		emit_signal("level_end")
	elif !has_node("Pizza") and !has_node("Cherry") and !has_node("Banana"):
		random.randomize()
		var spawn_choice = random.randi()%3

		if spawn_choice == 0:
			food = pizza_scene.instance()
		elif spawn_choice == 1:
			food = cherry_scene.instance()
		else:
			food = banana_scene.instance()

		food.position.x = random.randf_range(0, screen_size.x)
		food.position.y = -10
		add_child(food)
		food.connect("caught_food", self, "_on_caught_food")
		food.connect("missed_food", self, "_on_missed_food")

func _on_caught_food():
	init = false
	collect_player.play()
	player_face._set_happy_face()
	hunger_meter.set_value(hunger_meter.get_value() + 10)

func _on_missed_food():
	init = false
	argh_player.play()
	player_face._set_angry_face()
	hunger_meter.set_value(hunger_meter.get_value() - 10)
