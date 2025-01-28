extends Node

@onready var coin_label: Label = %CoinLabel
@export var hearts : Array[Node]

var coins = 0
var lives = 10

func lose_life():
	lives -= 1
	print(lives)
	for h in 10:
		if (h < lives):
			hearts[h].show()
		else:
			hearts[h].hide()
	if (lives == 0):
		get_tree().reload_current_scene()

func add_coin():
	coins += 1
	print (coins)
	coin_label.text = str(coins)
