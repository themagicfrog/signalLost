extends Node2D

@onready var text_bubble: Control = $"Text Bubble"
@onready var sprite = $AnimatedSprite2D  
#@onready var interaction_area: Area2D = $InteractionArea

var player_in_range = false

func _ready() -> void:
	text_bubble.hide_bubble()
	sprite.play("idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("talk"):
		text_bubble.show_bubble()
		sprite.play("angry")
