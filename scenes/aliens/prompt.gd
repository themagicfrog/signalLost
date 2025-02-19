extends Control

@onready var symbol_container: TextureRect = $SymbolContainer
@onready var word = preload("res://assets/art/language/yes.png")

func _ready() -> void:
	symbol_container.texture = word
	hide()

func _process(_delta: float) -> void:
	pass
