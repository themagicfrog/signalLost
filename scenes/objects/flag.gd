extends Area2D

var time: float = 0.0
var start_position: Vector2
const SCALE_AMOUNT = 1.5 
const SCALE_DURATION = 0.2 

func _ready() -> void:
	add_to_group("checkpoint")
	start_position = position

func _process(delta: float) -> void:
	time += delta
	position.y = start_position.y + sin(time * 1.5) * 20

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.death_pos = global_position

		var tween = create_tween()
		tween.set_trans(Tween.TRANS_ELASTIC) 
		tween.set_ease(Tween.EASE_OUT)

		tween.tween_property(self, "scale", Vector2.ONE * SCALE_AMOUNT, SCALE_DURATION)
		tween.tween_property(self, "scale", Vector2.ONE, SCALE_DURATION)
