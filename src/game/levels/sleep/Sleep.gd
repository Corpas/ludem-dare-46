extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var bed_scene = load("res://src/drops/sleep/Bed.tscn")
onready var screen_size = get_viewport().get_visible_rect().size
onready var sleep_meter = $Overlay/Control/SleepMeter
onready var random = RandomNumberGenerator.new()
onready var player = $Player

var init = true

signal level_end

# Called when the node enters the scene tree for the first time.
func _ready():
	player.get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var bed
	
	var sleep_value = sleep_meter.get_value()
	if (sleep_value == 0 and init == false) or sleep_value == 100:
		emit_signal("level_end")
	elif !has_node("Bed"):
		random.randomize()
		bed = bed_scene.instance()
		bed.position.x = random.randf_range(0, screen_size.x)
		bed.position.y = -10
		add_child(bed)
		bed.connect("caught_bed", self, "_on_caught_bed")
		bed.connect("missed_bed", self, "_on_missed_bed")
		
func _on_caught_bed():
	init = false
	sleep_meter.set_value(sleep_meter.get_value() + 10)

func _on_missed_bed():
	init = false
	sleep_meter.set_value(sleep_meter.get_value() - 10)
