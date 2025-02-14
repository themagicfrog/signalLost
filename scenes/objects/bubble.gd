extends Area2D

@onready var manager: Node = %Manager
@onready var sprite: Sprite2D = $Sprite2D 

var time: float = 0.0
var start_position: Vector2
var normal_size: Vector2
var collected = false
const RESPAWN_TIME = 2 
const SCALE_DURATION = 1.25

func _ready() -> void:
	start_position = position
	normal_size = sprite.scale 

func _process(delta: float) -> void:
	time += delta
	position.y = start_position.y + sin(time * 1.5) * 20

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player" and !collected):
		collected = true
		sprite.hide()
		$CPUParticles2D.emitting = true
		manager.addOxygen()
		
		set_deferred("monitoring", false)
		set_deferred("monitorable", false)
		
		await get_tree().create_timer(RESPAWN_TIME).timeout
		respawn()

func respawn() -> void:
	collected = false
	sprite.scale = Vector2.ZERO
	sprite.show()
	
	var tween = create_tween()
	tween.tween_property(sprite, "scale", normal_size, SCALE_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	monitoring = true
	monitorable = true
