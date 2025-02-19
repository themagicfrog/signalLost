extends Node2D

@onready var prompt: Control = $Prompt
@onready var sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea

var player_in_range = false

func _ready() -> void:
	sprite.play("idle")

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.owner.name == "Player":
		player_in_range = true
		prompt.show()
		area.owner.current_alien = self
		area.owner.start_alien_interaction()

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area.owner.name == "Player":
		player_in_range = false
		prompt.hide()
		sprite.play("idle")
		area.owner.end_alien_interaction()

func play_angry_animation() -> void:
	sprite.play("angry")
	await get_tree().create_timer(1.5).timeout
	sprite.play("idle")
