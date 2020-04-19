extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_level
var current_player
onready var level_scene = load("res://src/game/levels/Level.tscn")
onready var hunger_script = load("res://src/game/levels/hunger/Hunger.gd")
onready var sleep_script = load("res://src/game/levels/sleep/Sleep.gd")

var hunger_meter
var sleep_meter
var current_script = "hunger"

var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = level_scene.instance()
	current_level.set_script(hunger_script)
	current_level.connect("level_end", self, "_load_next_level")
	add_child(current_level)
	hunger_meter = get_node("Level/Overlay/Control/HungerMeter")
	sleep_meter = get_node("Level/Overlay/Control/SleepMeter")
	current_player = get_node("Level/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if timer > 10:
		if current_script == "hunger":
			sleep_meter.set_value(sleep_meter.get_value() - 10)
		elif current_script == "sleep":
			hunger_meter.set_value(hunger_meter.get_value() - 10)
		
		timer = 0.0


func _load_next_level():
	var hunger_value = hunger_meter.get_value()
	var sleep_value = sleep_meter.get_value()
	var current_player_pos = Vector2(current_player.position.x, current_player.position.y)
	
	var new_level = level_scene.instance()
	
	print("loading new level")
	
	if hunger_value > 0 and hunger_value < 100:
		current_script = "hunger"
		new_level.set_script(hunger_script)
		_configure_new_level(new_level, hunger_value, sleep_value, current_player_pos)
	elif sleep_value > 0 and sleep_value < 100:
		current_script = "sleep"
		new_level.set_script(sleep_script)
		_configure_new_level(new_level, hunger_value, sleep_value, current_player_pos)
	else:
		#check for win/lose
		var total = hunger_value + sleep_value
		if total == 200:
			#win
			print("You win")
		elif total > 0 and total < 200:
			# do something better here
			hunger_meter.set_value(50)
			sleep_meter.set_value(50)
		else:
			#lose
			print("You lose")

func _configure_new_level(new_level, hunger_value, sleep_value, current_player_pos):
	timer = 0.0
	new_level.connect("level_end", self, "_load_next_level")
	remove_child(current_level)
	current_level = new_level
	add_child(current_level)
	hunger_meter = get_node("Level/Overlay/Control/HungerMeter")
	sleep_meter = get_node("Level/Overlay/Control/SleepMeter")
	current_player = get_node("Level/Player")
	hunger_meter.set_value(hunger_value)
	sleep_meter.set_value(sleep_value)
	current_player.position.x = current_player_pos.x
	current_player.position.y = current_player_pos.y
