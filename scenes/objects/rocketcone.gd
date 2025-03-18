extends Area2D

@onready var manager: Node = %Manager
@onready var sprite: Sprite2D = $Sprite2D 
@onready var sfx_magic: AudioStreamPlayer2D = $sfx_magic
@onready var sfx_collect: AudioStreamPlayer2D = $sfx_collect

var time: float = 0.0
var start_position: Vector2
var normal_size: Vector2
var collected = false

func _ready() -> void:
	start_position = position

func _process(delta: float) -> void:
	time += delta
	position.y = start_position.y + sin(time * 1.5) * 30

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player" and !collected):
		collected = true
		sprite.hide()
		sfx_magic.play()
		sfx_collect.play()
		$CPUParticles2D.emitting = true
		
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		
