extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var food_scene = load("res://src/drops/Food.tscn")
onready var random = RandomNumberGenerator.new()
onready var screen_size = get_viewport().get_visible_rect().size
onready var hunger_meter = $"Overlay/Control/HungerMeter"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !has_node("Food"):
		var food = food_scene.instance()
		random.randomize()
		food.position.x = random.randf_range(0, screen_size.x)
		food.position.y = -10
		add_child(food)
		food.connect("caught_food", self, "_on_caught_food")
		food.connect("missed_food", self, "_on_missed_food")

func _on_caught_food():
	hunger_meter.set_value(hunger_meter.get_value() + 10)
	
func _on_missed_food():
	hunger_meter.set_value(hunger_meter.get_value() - 10)
