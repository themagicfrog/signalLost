extends RigidBody2D

@onready var manager: Node = %Manager
var has_damaged_player = false  

func _ready() -> void:
	freeze = true

func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player" and not has_damaged_player):
		has_damaged_player = true
		manager.decreaseOxygen()
		manager.lose_life()
		body.take_damage()  
