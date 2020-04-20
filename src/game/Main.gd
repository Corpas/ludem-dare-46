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
onready var stopped_script = load("res://src/game/levels/game-over/GameStopped.gd")
onready var random = RandomNumberGenerator.new()
onready var screen_size = get_viewport().get_visible_rect().size
onready var bomb_scene = load("res://src/drops/enemy/Bomb.tscn")
onready var audioplayer = $AudioStreamPlayer2D

var hunger_meter
var sleep_meter
var current_script = "hunger"

var timer = 0.0

const MAX_POINTS = 200
const MAX_TIMER = 10

var bomb_count = 0
const MAX_BOMBS = 8
var bomb_timer = 3
const MAX_BOMB_TIME = 3
var bombs = []

## 8 bombs - one every 3 sec - removed after 24 sec

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_start_game(hunger_script)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !paused:
		timer += delta
		
		bomb_timer += delta
		
		if bomb_count < MAX_BOMBS and bomb_timer > MAX_BOMB_TIME:
			# drop a bomb
			random.randomize()
			var bomb = bomb_scene.instance()
			bomb.position.x = random.randf_range(0, screen_size.x)
			bomb.position.y = -10
			add_child(bomb)
			bomb_count += 1
			bomb_timer = 0
			bombs.push_back(bomb)
			bomb.connect("touched_bomb", self, "_on_touched_bomb")
			bomb.connect("remove_bomb", self, "_on_remove_bomb")
		
		if timer > MAX_TIMER:
			_drop_inactive_meters()
			
			timer = 0.0
	else:
		if Input.is_action_pressed("ui_accept"):
			_remove_bombs()
			_restart_game(hunger_script)

func _on_remove_bomb(bomb):
	bomb_count -= 1
	bombs.erase(bomb)
	audioplayer.play()

func _remove_bombs():
	for bomb in bombs:
		remove_child(bomb)
	bombs = []
	bomb_count = 0

func _start_game(script):
	timer = 0.0
	paused = false
	current_level = level_scene.instance()
	current_level.set_script(script)
	add_child(current_level)
	current_level.connect("level_end", self, "_load_next_level")
	hunger_meter = get_node("Level/Overlay/Control/HungerMeter")
	sleep_meter = get_node("Level/Overlay/Control/SleepMeter")
	current_player = get_node("Level/Player")
	current_animation_player = get_node("Level/Player/AnimationPlayer")
	hunger_meter.set_value(50)
	sleep_meter.set_value(50)

func _restart_game(script):
	remove_child(current_level)
	_start_game(script)

func _load_next_level():
	var hunger_value = hunger_meter.get_value()
	var sleep_value = sleep_meter.get_value()
	
	var new_level = level_scene.instance()
	
	var has_available_level = _has_available_level()
	
	if has_available_level and hunger_value < 100:
		current_script = "hunger"
		new_level.set_script(hunger_script)
		_configure_new_level(new_level)
	elif has_available_level and sleep_value < 100:
		current_script = "sleep"
		new_level.set_script(sleep_script)
		_configure_new_level(new_level)
	else:
		#check for win/lose
		_restart_game(stopped_script)
		paused = true
		_remove_bombs()
		
		var total = hunger_value + sleep_value
		if total == MAX_POINTS:
			#win
			pass
		else:
			#lose
			pass

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

func _on_touched_bomb(touched_bomb):
	audioplayer.play()
	_drop_active_meter()
	remove_child(touched_bomb)
	bomb_count -= 1
	bombs.erase(touched_bomb)

func _drop_inactive_meters():
	if current_script == "hunger":
		var current_sleep_value = sleep_meter.get_value()
		sleep_meter.set_value(current_sleep_value - 10)
	elif current_script == "sleep":
		var current_hunger_value = hunger_meter.get_value()
		hunger_meter.set_value(current_hunger_value - 10)

func _drop_active_meter():
	if current_script == "sleep":
		var current_sleep_value = sleep_meter.get_value()
		sleep_meter.set_value(current_sleep_value - 10)
	elif current_script == "hunger":
		var current_hunger_value = hunger_meter.get_value()
		hunger_meter.set_value(current_hunger_value - 10)
