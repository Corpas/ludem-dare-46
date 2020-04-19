extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_level
var current_player
var current_animation_player
onready var level_scene = load("res://src/game/levels/Level.tscn")
onready var hunger_script = load("res://src/game/levels/hunger/Hunger.gd")
onready var sleep_script = load("res://src/game/levels/sleep/Sleep.gd")

var hunger_meter
var sleep_meter
var current_script = "hunger"

var timer = 0.0

const MAX_POINTS = 200
const MAX_TIMER = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = level_scene.instance()
	current_level.set_script(hunger_script)
	current_level.connect("level_end", self, "_load_next_level")
	add_child(current_level)
	hunger_meter = get_node("Level/Overlay/Control/HungerMeter")
	sleep_meter = get_node("Level/Overlay/Control/SleepMeter")
	current_player = get_node("Level/Player")
	current_animation_player = get_node("Level/Player/AnimationPlayer")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	if timer > MAX_TIMER:
		if current_script == "hunger":
			var current_sleep_value = sleep_meter.get_value()
			sleep_meter.set_value(current_sleep_value - 10)
		elif current_script == "sleep":
			var current_hunger_value = hunger_meter.get_value()
			hunger_meter.set_value(hunger_meter.get_value() - 10)
		
		timer = 0.0


func _load_next_level():
	var hunger_value = hunger_meter.get_value()
	var sleep_value = sleep_meter.get_value()
	
	var new_level = level_scene.instance()
	
	var has_available_level = _has_available_level()
	
	
	if has_available_level and hunger_value < 100:
		print("creating hunger")
		current_script = "hunger"
		new_level.set_script(hunger_script)
		_configure_new_level(new_level)
	elif has_available_level and sleep_value < 100:
		print("creating sleep")
		current_script = "sleep"
		new_level.set_script(sleep_script)
		_configure_new_level(new_level)
	else:
		print("in else for some reason")
		#check for win/lose
		var total = hunger_value + sleep_value
		if total == MAX_POINTS:
			#win
			print("You win")
		else:
			#lose
			print("You lose")

func _has_available_level():
	var total_points = hunger_meter.get_value() + sleep_meter.get_value()
	if total_points > 0:
		return true
	
	return false

func _configure_new_level(new_level):
	var current_player_pos = Vector2(current_player.position.x, current_player.position.y)
	var current_player_velocity = Vector2(current_player.velocity.x, current_player.velocity.y)
	var current_animation = current_animation_player.current_animation
	var hunger_value = hunger_meter.get_value()
	var sleep_value = sleep_meter.get_value()
	
	timer = 0.0
	new_level.connect("level_end", self, "_load_next_level")
	remove_child(current_level)
	current_level = new_level
	add_child(current_level)
	hunger_meter = get_node("Level/Overlay/Control/HungerMeter")
	sleep_meter = get_node("Level/Overlay/Control/SleepMeter")
	current_player = get_node("Level/Player")
	current_animation_player = get_node("Level/Player/AnimationPlayer")
	current_animation_player.play(current_animation)
	hunger_meter.set_value(hunger_value)
	sleep_meter.set_value(sleep_value)
	current_player.position.x = current_player_pos.x
	current_player.position.y = current_player_pos.y
	current_player.velocity.x = current_player_velocity.x
	current_player.velocity.y = current_player_velocity.y
