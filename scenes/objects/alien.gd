extends Node2D

@onready var text_bubble: Control = $"Text Bubble"
@onready var sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

var player_in_range = false

func _ready() -> void:
	text_bubble.hide_bubble()
	sprite.play("idle")

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.owner.name == "Player":
		player_in_range = true
		text_bubble.show_bubble() 
		sprite.play("angry")
		print("Player can now interact with alien")

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area.owner.name == "Player":
		player_in_range = false
		text_bubble.hide_bubble()
		sprite.play("idle")
		print("Player left interaction range")
