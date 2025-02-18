extends Control

@onready var symbol_container = $SymbolContainer
@onready var word = preload("res://assets/art/language/no.png")

func _ready() -> void:
	hide()
	symbol_container.texture = word

func show_bubble(_texture: Texture2D = null) -> void:
	show()

func hide_bubble() -> void:
	hide()

func _process(_delta: float) -> void:
	pass
