extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -500.0
const SPACE_GRAVITY = 1000
const MAX_JUMPS = 2  
const SHAKE_THRESHOLD = 800.0  
const MAX_SHAKE = 0.6  
const FLASH_DURATION = 0.1  
const NUMBER_OF_FLASHES = 3  
const SLIDE = 40

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2Ds
@onready var manager: Node = %Manager
@onready var camera: Camera2D = $Camera2D  

var previous_velocity := Vector2.ZERO
enum GravityDirection { DOWN = 0, UP = 1, LEFT = 2, RIGHT = 3 }
var current_gravity = GravityDirection.DOWN
var jumps_remaining = MAX_JUMPS

func _physics_process(delta: float) -> void:

	previous_velocity = velocity
	
	if Input.is_action_just_pressed("gdown"):
		current_gravity = GravityDirection.DOWN
		rotation_degrees = 0
		manager.decreaseOxygen()
	elif Input.is_action_just_pressed("gup"):
		current_gravity = GravityDirection.UP
		rotation_degrees = 180
		manager.decreaseOxygen()
	elif Input.is_action_just_pressed("gleft"):
		current_gravity = GravityDirection.LEFT
		rotation_degrees = 90
		manager.decreaseOxygen()
	elif Input.is_action_just_pressed("gright"):
		current_gravity = GravityDirection.RIGHT
		rotation_degrees = -90
		manager.decreaseOxygen()
	
	match current_gravity:
		GravityDirection.DOWN, GravityDirection.UP:
			if is_on_floor():
				jumps_remaining = MAX_JUMPS
		GravityDirection.LEFT, GravityDirection.RIGHT:
			if is_on_wall():  
				jumps_remaining = MAX_JUMPS
	
	match current_gravity:
		GravityDirection.DOWN, GravityDirection.UP:
			velocity.y += SPACE_GRAVITY * delta * (1 if current_gravity == GravityDirection.DOWN else -1)
			if Input.is_action_just_pressed("w" if current_gravity == GravityDirection.DOWN else "s") or \
			   Input.is_action_just_pressed("ui_up" if current_gravity == GravityDirection.DOWN else "ui_down"):
				if jumps_remaining > 0:
					velocity.y = JUMP_VELOCITY * (1 if current_gravity == GravityDirection.DOWN else -1)
					jumps_remaining -= 1

			var h_direction = Input.get_axis("a", "d")
			if h_direction == 0:  
				h_direction = Input.get_axis("ui_left", "ui_right")
			
			velocity.x = h_direction * SPEED if h_direction else move_toward(velocity.x, 0, SLIDE)

			if h_direction != 0 and sprite_2d: 
				sprite_2d.flip_h = h_direction < 0 if current_gravity == GravityDirection.DOWN else h_direction > 0
			
		GravityDirection.LEFT, GravityDirection.RIGHT:
			velocity.x += SPACE_GRAVITY * delta * (-1 if current_gravity == GravityDirection.LEFT else 1)
			if Input.is_action_just_pressed("a" if current_gravity == GravityDirection.RIGHT else "d") or \
			   Input.is_action_just_pressed("ui_left" if current_gravity == GravityDirection.RIGHT else "ui_right"):
				if jumps_remaining > 0:
					velocity.x = JUMP_VELOCITY * (1 if current_gravity == GravityDirection.RIGHT else -1)
					jumps_remaining -= 1

			var v_direction = Input.get_axis("w", "s")
			if v_direction == 0:  
				v_direction = Input.get_axis("ui_up", "ui_down")
				
			velocity.y = v_direction * SPEED if v_direction else move_toward(velocity.y, 0, SLIDE)

			if v_direction != 0 and sprite_2d:  
				sprite_2d.flip_h = v_direction < 0 if current_gravity == GravityDirection.LEFT else v_direction > 0

	move_and_slide()
	
	check_impact()

func check_impact() -> void:
	if is_on_floor() or is_on_ceiling() or is_on_wall():
		var impact_velocity: float
		match current_gravity:
			GravityDirection.DOWN, GravityDirection.UP:
				impact_velocity = abs(previous_velocity.y)
			GravityDirection.LEFT, GravityDirection.RIGHT:
				impact_velocity = abs(previous_velocity.x)
		
		if impact_velocity > SHAKE_THRESHOLD:
			var shake_intensity = clamp(impact_velocity / 2000.0, 0.0, MAX_SHAKE)
			apply_screen_shake(shake_intensity)

func apply_screen_shake(intensity: float) -> void:
	if camera:
		var tween = create_tween()
		tween.tween_method(shake_camera, 0.0, intensity, 0.1)
		tween.tween_method(shake_camera, intensity, 0.0, 0.3)

func shake_camera(intensity: float) -> void:
	camera.offset = Vector2(
		randf_range(-1.0, 1.0) * intensity * 10,
		randf_range(-1.0, 1.0) * intensity * 10
	)

func take_damage() -> void:
	flash_effect()

func flash_effect() -> void:
	var tween = create_tween()
	for i in range(NUMBER_OF_FLASHES):
		tween.tween_property(sprite_2d, "modulate:a", 0.2, FLASH_DURATION)
		tween.tween_property(sprite_2d, "modulate:a", 1.0, FLASH_DURATION)
