extends Node
class_name DialogueManager

const DIALOGUES = {
	"alien_greeting_1": {
		"alien_sprite": "idle",
		"alien_text": ["yes", "no"],  
		"options": {
			"symbols": ["yes", "no"],  
			"effects": {
				1: {
					"type": ["heal", "door"],
					"next_dialogue": "alien_greeting_1"
				},
				2: {
					"type": "damage",
					"next_dialogue": "alien_greeting_1"
				}
			}
		}
	}
}

func get_dialogue(dialogue_id: String) -> Dictionary:
	if DIALOGUES.has(dialogue_id):
		return DIALOGUES[dialogue_id]
	return {}

func process_effect(effect: Dictionary, player: Node2D, alien: Node2D) -> void:
	if effect.type is Array:
		for effect_type in effect.type:
			process_single_effect(effect_type)
	else:
		process_single_effect(effect.type)

func process_single_effect(effect_type: String) -> void:
	match effect_type:
		"heal":
			var manager = get_node_or_null("%Manager")
			manager.refillOxygen()
		"damage":
			var manager = get_node_or_null("%Manager")
			manager.decreaseOxygen()
		"door":
			var plant_doors = get_tree().get_nodes_in_group("plant_door")
			for door in plant_doors:
				door.hide_door()
