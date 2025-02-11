extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -500.0
const SPACE_GRAVITY = 980
@onready var sprite_2d: Sprite2D = $Sprite2D

enum GravityDirection { DOWN = 0, UP = 1, LEFT = 2, RIGHT = 3 }
var current_gravity = GravityDirection.DOWN

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("gdown"):
		current_gravity = GravityDirection.DOWN
		rotation_degrees = 0
	elif Input.is_action_just_pressed("gup"):
		current_gravity = GravityDirection.UP
		rotation_degrees = 180
	elif Input.is_action_just_pressed("gleft"):
		current_gravity = GravityDirection.LEFT
		rotation_degrees = 90
	elif Input.is_action_just_pressed("gright"):
		current_gravity = GravityDirection.RIGHT
		rotation_degrees = -90
	
	match current_gravity:
		GravityDirection.DOWN, GravityDirection.UP:
			velocity.y += SPACE_GRAVITY * delta * (1 if current_gravity == GravityDirection.DOWN else -1)
			if Input.is_action_just_pressed("w" if current_gravity == GravityDirection.DOWN else "s"):
				velocity.y = JUMP_VELOCITY * (1 if current_gravity == GravityDirection.DOWN else -1)

			var h_direction := Input.get_axis("a", "d")
			velocity.x = h_direction * SPEED if h_direction else move_toward(velocity.x, 0, 25)

			if h_direction != 0:
				sprite_2d.flip_h = h_direction < 0 if current_gravity == GravityDirection.DOWN else h_direction > 0
			
		GravityDirection.LEFT, GravityDirection.RIGHT:
			velocity.x += SPACE_GRAVITY * delta * (-1 if current_gravity == GravityDirection.LEFT else 1)
			if Input.is_action_just_pressed("d" if current_gravity == GravityDirection.LEFT else "a"):
				velocity.x = JUMP_VELOCITY * (-1 if current_gravity == GravityDirection.LEFT else 1)

			var v_direction := Input.get_axis("w", "s")
			velocity.y = v_direction * SPEED if v_direction else move_toward(velocity.y, 0, 25)

			if v_direction != 0:
				sprite_2d.flip_h = v_direction > 0 if current_gravity == GravityDirection.LEFT else v_direction < 0

	move_and_slide()
