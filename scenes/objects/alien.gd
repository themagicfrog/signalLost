extends Node2D

@onready var text_bubble: Control = $"Text Bubble"
@onready var interaction_area: Area2D = $InteractionArea

var player_in_range = false

func _ready() -> void:
	text_bubble.hide_bubble()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("talk"):
	#and player_in_range:  # "E" key
		#print("show bubble")
		text_bubble.show_bubble()

#func _on_interaction_area_area_entered(area: Area2D) -> void:
	#print("Area entered: ", area.name)  # Debug print
	#if area.owner.name == "Player":
		#print("player entered range")
		#player_in_range = true
#
#func _on_interaction_area_area_exited(area: Area2D) -> void:
	#print("Area exited: ", area.name)  # Debug print
	#if area.owner.name == "Player":
		#print("player left range")
		#player_in_range = false
		#text_bubble.hide_bubble()
