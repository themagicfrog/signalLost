extends Control

@onready var symbol_container = $SymbolContainer
# Load the texture when the script starts
@onready var word = preload("res://assets/art/language/danger.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start hidden
	#hide()
	# You can immediately set a default texture if you want
	symbol_container.texture = word

func show_bubble(texture: Texture2D = null) -> void:
	if texture:
		symbol_container.texture = texture
	else:
		# Use default texture if none provided
		symbol_container.texture = word
	show()

func hide_bubble() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
