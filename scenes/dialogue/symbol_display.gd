extends Control

@onready var symbol_container: TextureRect = $SymbolContainer

func display(symbols: Array) -> void:
	if symbols.size() > 0:
		var symbol_path = "res://assets/symbols/" + symbols[0] + ".png"
		var texture = load(symbol_path)
		if texture:
			symbol_container.texture = texture
		show()
	else:
		hide() 
