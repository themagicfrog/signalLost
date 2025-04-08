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
					"type": ["heal", ["door", "door_1"]],
					"next_dialogue": "alien_greeting_1"
				},
				2: {
					"type": "damage",
					"next_dialogue": "alien_greeting_1"
				}
			}
		}
	},
	"alien_greeting_2": {
		"alien_sprite": "idle",
		"alien_text": ["yes", "no"],  
		"options": {
			"symbols": ["yes", "no"],  
			"effects": {
				1: {
					"type": ["heal", ["door", "door_2"]],
					"next_dialogue": "alien_greeting_2"
				},
				2: {
					"type": "damage",
					"next_dialogue": "alien_greeting_2"
				}
			}
		}
	}
}

func get_dialogue(dialogue_id: String) -> Dictionary:
	if DIALOGUES.has(dialogue_id):
		return DIALOGUES[dialogue_id]
	return {}

func process_effect(effect: Dictionary, alien: Node2D) -> void:
	if effect.type is Array:
		for effect_type in effect.type:
			if effect_type is Array and effect_type[0] == "door":
				process_single_effect(effect_type, alien)
			else:
				process_single_effect(effect_type, alien)
	else:
		process_single_effect(effect.type, alien)

func process_single_effect(effect_type: Variant, alien: Node2D) -> void:
	if effect_type is Array and effect_type[0] == "door":
		var door_id = effect_type[1]
		var plant_doors = get_tree().get_nodes_in_group("plant_door")
		for door in plant_doors:
			if door.door_id == door_id:
				door.hide_door()
	else:
		match effect_type:
			"heal":
				var manager = get_node_or_null("%Manager")
				manager.refillOxygen()
			"damage":
				var manager = get_node_or_null("%Manager")
				manager.decreaseOxygen()
				alien.play_animation("angry")
