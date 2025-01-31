extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -2000.0
@onready var sprite_2d: Sprite2D = $Sprite2D

var gravity = get_gravity()
var graivtyDirection = -0.1

func jump():
	velocity.y = JUMP_VELOCITY
	
func jump_away(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x

func _physics_process(delta: float) -> void:
	
	if !is_on_floor():
			velocity += get_gravity() * delta * graivtyDirection

	move_and_slide()
	
	
