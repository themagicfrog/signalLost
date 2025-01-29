extends CharacterBody2D

const SPEED = 500.0
const JUMP_VELOCITY = -1000.0
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

var jumpEvenIfNotOnGround = true
var jumpWasPressed = false

func jump():
	velocity.y = JUMP_VELOCITY
	
func jump_away(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		jumpEvenIfNotOnGround = true
		if jumpWasPressed == true:
			velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("jump"):
		jumpWasPressed = true
		rememberJumpTime()
		if jumpEvenIfNotOnGround == true:
			velocity.y = JUMP_VELOCITY
	
	if !is_on_floor():
		coyoteTime()
		velocity += get_gravity() * delta
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 14)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
func coyoteTime():
	await get_tree().create_timer(0.15).timeout
	jumpEvenIfNotOnGround = false
	pass
	
func rememberJumpTime():
	await get_tree().create_timer(0.1).timeout
	jumpWasPressed = false
	pass
