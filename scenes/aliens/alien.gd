extends Node2D

@onready var prompt: Control = $Prompt
@onready var sprite = $AnimatedSprite2D
@onready var interaction_area = $InteractionArea
@onready var dialogue_manager = get_tree().get_first_node_in_group("dialogue_manager")

@export_group("Dialogue")
@export var initial_dialogue_id: String = "alien_greeting_1"
var current_dialogue_id: String
var current_dialogue: Dictionary
var player_in_range = false
var alien = 1

func _ready() -> void:
	sprite.play("idle")
	current_dialogue_id = initial_dialogue_id

func start_dialogue() -> void:
	current_dialogue = dialogue_manager.get_dialogue(current_dialogue_id)
	if current_dialogue.is_empty():
		return
		
	# Show alien's symbols
	display_symbols(current_dialogue.alien_text)
	# Play alien's animation if specified
	if current_dialogue.has("alien_sprite"):
		sprite.play(current_dialogue.alien_sprite)

func display_symbols(symbols: Array) -> void:
	# Update the symbol container directly since it's a TextureRect
	if symbols.size() > 0:
		# Use the first symbol from the array to determine which texture to load
		var symbol_name = symbols[0]  # e.g. "yes" or "no"
		var texture = load("res://assets/art/language/" + symbol_name + ".png")
		if texture:
			prompt.get_node("SymbolContainer").texture = texture
			prompt.show()
	else:
		prompt.hide()

func handle_player_choice(option: int) -> void:
	if current_dialogue.has("options") and current_dialogue.options.effects.has(option):
		var effect = current_dialogue.options.effects[option]
		dialogue_manager.process_effect(effect, get_tree().get_first_node_in_group("player"), self)
		
		# Check if there's a next dialogue to transition to
		if effect.has("next_dialogue"):
			current_dialogue_id = effect.next_dialogue

func play_animation(anim_name: String) -> void:
	sprite.play(anim_name)
	await sprite.animation_finished
	sprite.play("idle")

func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.owner.name == "Player":
		prompt.show()
		area.owner.current_alien = self
		area.owner.start_alien_interaction()
		start_dialogue()

func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area.owner.name == "Player":
		player_in_range = false
		prompt.hide()
		sprite.play("idle")
		area.owner.end_alien_interaction()
