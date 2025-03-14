extends RigidBody2D

@onready var manager: Node = %Manager
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var door := true

func _ready() -> void:
	freeze = true
	add_to_group("plant_door")

func hide_door() -> void:
	door = false
	animated_sprite_2d.play("descend")
	await animated_sprite_2d.animation_finished
	hide()
	$CollisionShape2D.set_deferred("disabled", true)
	$CollisionShape2D2.set_deferred("disabled", true)
	if has_node("Area2D"):
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D2.set_deferred("disabled", true)
		$Area2D.set_deferred("monitoring", false)
		$Area2D.set_deferred("monitorable", false)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" && door == true:
		manager.decreaseOxygen()
		body.flash()  
