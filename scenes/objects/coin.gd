extends Area2D

@onready var manager: Node = %Manager

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		queue_free()
		manager.add_coin()
