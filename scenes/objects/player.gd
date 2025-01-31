extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -500.0
const SPACE_GRAVITY = 980
@onready var sprite_2d: Sprite2D = $Sprite2D
#@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumpEvenIfNotOnGround = true
var jumpWasPressed = false
#var gravity = get_gravity()
var gravityDirection = -1

func jump():
	velocity.y = JUMP_VELOCITY
	
func jump_away(x):
	velocity.y = JUMP_VELOCITY
	velocity.x = x

func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		jumpEvenIfNotOnGround = true
		if jumpWasPressed == true:
			velocity.y = JUMP_VELOCITY * gravityDirection
	
	if Input.is_action_just_pressed("jump"):
		#jumpWasPressed = true
		#rememberJumpTime()
		#if jumpEvenIfNotOnGround == true:
		velocity.y = JUMP_VELOCITY * gravityDirection
	
	if !is_on_floor():
		#coyoteTime()
		velocity.y += SPACE_GRAVITY * delta * gravityDirection
		#b* gravityDirection
	
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
