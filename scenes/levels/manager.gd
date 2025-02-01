extends Node

@onready var oxygenLevel: Label = %OxygenLabel
@export var hearts : Array[Node]
@onready var timer: Timer = $"../UI/Timer"

var oxygen = 10
var lives = 5

func _ready():
	timer.start()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func lose_life():
	lives -= 1
	for h in lives:
		if (h < lives):
			hearts[h].show()
		else:
			hearts[h].hide()
	if (lives == 0):
		get_tree().reload_current_scene()

func addOxygen():
	oxygen += 10
	oxygenLevel.text = str(oxygen)
	
func _on_timer_timeout():
	if oxygen > 0:
		oxygen -= 1
	oxygenLevel.text = str(oxygen)
	if oxygen == 0:
		lose_life()
