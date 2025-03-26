extends Area2D


func _ready() -> void:
	add_to_group("checkpoint")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.death_pos = global_position
