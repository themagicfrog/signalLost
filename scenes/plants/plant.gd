extends RigidBody2D

@onready var manager: Node = %Manager

func _ready() -> void:
	freeze = true

func _process(_delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		manager.decreaseOxygen()
		body.flash()  
