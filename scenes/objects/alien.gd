extends Node2D

@export var bubble_symbol: Texture2D
@onready var text_bubble = $TextBubble

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		text_bubble.show_bubble(bubble_symbol)

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		text_bubble.hide_bubble() 
