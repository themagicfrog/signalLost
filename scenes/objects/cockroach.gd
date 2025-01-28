extends RigidBody2D

@onready var manager: Node = %Manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		var y_delta = position.y - body.position.y
		var x_delta = body.position.x - position.x
		if (y_delta > 500):
			print("kill cockroach")
			queue_free()
			body.jump()
		else:
			print("harm player")
			manager.lose_life()
			if (x_delta > 0):
				body.jump_away(500)
			else:
				body.jump_away(-500)
