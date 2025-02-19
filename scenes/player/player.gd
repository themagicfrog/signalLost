extends CharacterBody2D

const SPEED = 800.0
const JUMP_VELOCITY = -600.0
const SPACE_GRAVITY = 1100
const MAX_JUMPS = 2  
const FLASH_DURATION = 0.1  
const NUMBER_OF_FLASHES = 3  
const SLIDE = 50

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2Ds
@onready var manager: Node = %Manager
@onready var camera: Camera2D = $Camera2D  
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var particles2: CPUParticles2D = $CPUParticles2D2
@onready var option_1: Control = $Option1
@onready var option_2: Control = $Option2

var previous_velocity := Vector2.ZERO
enum GravityDirection { DOWN = 0, UP = 1, LEFT = 2, RIGHT = 3 }
var current_gravity = GravityDirection.DOWN
var jumps_remaining = MAX_JUMPS
var is_in_alien_zone := false
var current_option := 1
const SELECTED_OPTION := Color(1, 1, 1, 1) 
const UNSELECTED_OPTION := Color(0.8, 0.8, 0.8, 0.7) 
var current_alien: Node2D

func _physics_process(delta: float) -> void:
	previous_velocity = velocity
	
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
		GravityDirection.DOWN:
			particles.gravity = Vector2(0, 300)
			particles2.gravity = Vector2(0, 300)
		GravityDirection.UP:
			particles.gravity = Vector2(0, -300)
			particles2.gravity = Vector2(0, -300)
		GravityDirection.LEFT:
			particles.gravity = Vector2(-300, 0)
			particles2.gravity = Vector2(-300, 0)
		GravityDirection.RIGHT:
			particles.gravity = Vector2(300, 0)
			particles2.gravity = Vector2(300, 0)
	
	match current_gravity:
		GravityDirection.DOWN, GravityDirection.UP:
			if (current_gravity == GravityDirection.DOWN and is_on_floor()) or \
			   (current_gravity == GravityDirection.UP and is_on_ceiling()):
				sprite_2d.play("idle")
				particles.emitting = false
				particles2.emitting = false
				jumps_remaining = MAX_JUMPS
			else:
				sprite_2d.play("jump")
				particles.emitting = true
				particles2.emitting = true
		GravityDirection.LEFT, GravityDirection.RIGHT:
			if is_on_wall():
				sprite_2d.play("idle")
				particles.emitting = false
				particles2.emitting = false
				jumps_remaining = MAX_JUMPS
			else:
				sprite_2d.play("jump")
				particles.emitting = true
				particles2.emitting = true
	
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
		
		if impact_velocity > 800:
			var shake_intensity = clamp(impact_velocity / 2000.0, 0.0, 1)
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

func flash() -> void:
	var tween = create_tween()
	for i in range(NUMBER_OF_FLASHES):
		tween.tween_property(sprite_2d, "modulate:a", 0.2, FLASH_DURATION)
		tween.tween_property(sprite_2d, "modulate:a", 1.0, FLASH_DURATION)
	
	apply_screen_shake(0.7) 

func start_alien_interaction() -> void:
	is_in_alien_zone = true
	option_1.show()
	option_2.show()
	current_option = 1 
	update_option_appearance()

func end_alien_interaction() -> void:
	is_in_alien_zone = false
	option_1.hide()
	option_2.hide()
	current_alien = null 

func update_option_appearance() -> void:
	option_1.modulate = SELECTED_OPTION if current_option == 1 else UNSELECTED_OPTION
	option_2.modulate = SELECTED_OPTION if current_option == 2 else UNSELECTED_OPTION

func select_current_option() -> void:
	if current_option == 1:
		handle_option_1()
	else:
		handle_option_2()
	
	end_alien_interaction()

func handle_option_1() -> void:
	if current_alien:
		current_alien.play_angry_animation()
	await get_tree().create_timer(1.0).timeout
	manager.decreaseOxygen() 
	flash()

func handle_option_2() -> void:
	manager.refillOxygen() 

func _process(_delta: float) -> void:
	if is_in_alien_zone:
		if Input.is_action_just_pressed("toggle"):
			current_option = 2 if current_option == 1 else 1
			update_option_appearance()
		
		if Input.is_action_just_pressed("confirm"): 
			select_current_option()
