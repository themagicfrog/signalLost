extends Node

@onready var oxygen_bar: ProgressBar = $"../UI/Oxygen/OxygenBar"
@onready var hearts: Array[Node] = []
@onready var timer: Timer = $"../UI/Timer"

const OXYGEN_REFILL = 14 
var oxygen = 100

func _ready():

	oxygen_bar.min_value = 0
	oxygen_bar.max_value = 100
	oxygen_bar.step = 1
	oxygen_bar.value = oxygen
	
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func addOxygen():
	oxygen = min(oxygen + OXYGEN_REFILL, 100)
	oxygen_bar.value = oxygen
	
func refillOxygen():
	oxygen = 100
	oxygen_bar.value = oxygen

func decreaseOxygen():
	if oxygen > 0:
		oxygen -= 25
	oxygen_bar.value = oxygen
	
func _on_timer_timeout():
	if oxygen > 0:
		oxygen -= 2
		oxygen_bar.value = oxygen
	else:
		get_tree().reload_current_scene()
