extends CharacterBody2D

const SPEED = 800.0
const JUMP_VELOCITY = -600.0
const SPACE_GRAVITY = 1100
const MAX_JUMPS = 2  
const FLASH_DURATION = 0.1  
const NUMBER_OF_FLASHES = 3  
const SLIDE = 50
const OXYGEN_RED = 25
const OXYGEN_OHNO = 15
const INITIAL_ZOOM = Vector2(0.35, 0.35)  
const FINAL_ZOOM = Vector2(0.9, 0.9)  
const ZOOM_DURATION = 1.5  
const KEY_FADE_DURATION = 0.2
const KEY_FADE_OUT_DURATION = 0.5

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2Ds
@onready var manager: Node = %Manager
@onready var camera: Camera2D = $Camera2D  
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var particles2: CPUParticles2D = $CPUParticles2D2
@onready var option_1: Control = $Option1
@onready var option_2: Control = $Option2
@onready var plant_door: RigidBody2D = $"../../Sections/Sky/Plants/PlantDoor"
@onready var animated_sprite_2_ds: AnimatedSprite2D = $AnimatedSprite2Ds
@onready var dialogue_manager = get_tree().get_first_node_in_group("dialogue_manager")

@onready var sfx_jump: AudioStreamPlayer = $"Sound Effects/sfx_jump"
@onready var sfx_jetpack: AudioStreamPlayer = $"Sound Effects/sfx_jetpack"
@onready var sfx_whoosh: AudioStreamPlayer = $"Sound Effects/sfx_whoosh"
@onready var sfx_click: AudioStreamPlayer = $"Sound Effects/sfx_click"
@onready var sfx_retroselect: AudioStreamPlayer = $"Sound Effects/sfx_retroselect"

@onready var w_key: TextureRect = $HBoxContainer/w
@onready var a_key: TextureRect = $HBoxContainer/a
@onready var s_key: TextureRect = $HBoxContainer/s
@onready var d_key: TextureRect = $HBoxContainer/d
@onready var up_key: TextureRect = $HBoxContainer2/up
@onready var down_key: TextureRect = $HBoxContainer2/down
@onready var right_key: TextureRect = $HBoxContainer2/right
@onready var left_key: TextureRect = $HBoxContainer2/left


var previous_velocity := Vector2.ZERO
enum GravityDirection { DOWN = 0, UP = 1, LEFT = 2, RIGHT = 3 }
var current_gravity = GravityDirection.DOWN
var jumps_remaining = MAX_JUMPS
var is_in_alien_zone := false
var current_option := 1
const SELECTED_OPTION := Color(1, 1, 1, 1) 
const UNSELECTED_OPTION := Color(0.8, 0.8, 0.8, 0.7) 
var current_alien: Node2D

func _ready() -> void:
	manager.oxygen_level_changed.connect(_on_oxygen_level_changed)

	camera.zoom = INITIAL_ZOOM
	w_key.modulate.a = 0
	a_key.modulate.a = 0
	s_key.modulate.a = 0
	d_key.modulate.a = 0
	up_key.modulate.a = 0
	down_key.modulate.a = 0
	right_key.modulate.a = 0
	left_key.modulate.a = 0
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_interval(3.0)
	tween.tween_property(camera, "zoom", FINAL_ZOOM, ZOOM_DURATION)
	
	tween.tween_property(up_key, "modulate:a", 1.0, KEY_FADE_DURATION)
	tween.tween_property(down_key, "modulate:a", 1.0, KEY_FADE_DURATION)
	tween.tween_property(right_key, "modulate:a", 1.0, KEY_FADE_DURATION)
	tween.tween_property(left_key, "modulate:a", 1.0, KEY_FADE_DURATION)
	tween.tween_property(w_key, "modulate:a", 1.0, KEY_FADE_DURATION)
	tween.tween_property(a_key, "modulate:a", 1.0, KEY_FADE_DURATION)
	tween.tween_property(s_key, "modulate:a", 1.0, KEY_FADE_DURATION)
	tween.tween_property(d_key, "modulate:a", 1.0, KEY_FADE_DURATION)

func _on_oxygen_level_changed(oxygen_amount: float) -> void:
	if oxygen_amount <= 15:
		sprite_2d.play("ohno")
	elif oxygen_amount <= 30:
		sprite_2d.play("red")

func _physics_process(delta: float) -> void:
	previous_velocity = velocity
	sfx_whoosh.pitch_scale = randf_range(0.3, 0.6)
	sfx_whoosh.play()
		
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
				if manager.oxygen <= OXYGEN_OHNO:
					sprite_2d.play("ohno")
				elif manager.oxygen <= OXYGEN_RED:
					sprite_2d.play("red")
				else:
					sprite_2d.play("idle")
				particles.emitting = false
				particles2.emitting = false
				jumps_remaining = MAX_JUMPS
				sfx_jetpack.stop()
			else:
				if manager.oxygen <= OXYGEN_OHNO:
					sprite_2d.play("jump_ohno")
				elif manager.oxygen <= OXYGEN_RED:
					sprite_2d.play("jump_red")
				else:
					sprite_2d.play("jump")
				particles.emitting = true
				particles2.emitting = true
				if not sfx_jetpack.playing:
					sfx_jetpack.play()
		GravityDirection.LEFT, GravityDirection.RIGHT:
			if is_on_wall():
				if manager.oxygen <= OXYGEN_OHNO:
					sprite_2d.play("ohno")
				elif manager.oxygen <= OXYGEN_RED:
					sprite_2d.play("red")
				else:
					sprite_2d.play("idle")
				particles.emitting = false
				particles2.emitting = false
				jumps_remaining = MAX_JUMPS
				sfx_jetpack.stop()
			else:
				sprite_2d.play("jump")
				particles.emitting = true
				particles2.emitting = true
				if not sfx_jetpack.playing:
					sfx_jetpack.play()
	
	match current_gravity:
		GravityDirection.DOWN, GravityDirection.UP:
			velocity.y += SPACE_GRAVITY * delta * (1 if current_gravity == GravityDirection.DOWN else -1)
			if Input.is_action_just_pressed("w" if current_gravity == GravityDirection.DOWN else "s") or \
			   Input.is_action_just_pressed("ui_up" if current_gravity == GravityDirection.DOWN else "ui_down"):
				if jumps_remaining > 0:
					sfx_jump.pitch_scale = randf_range(0.2, 0.5)
					sfx_jump.play()
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
					sfx_jump.pitch_scale = randf_range(0.2, 0.5)
					sfx_jump.play()
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

func start_alien_interaction() -> void:
	if current_alien and dialogue_manager:
		# Make sure we're dealing with an alien node
		if not current_alien.has_method("start_dialogue"):
			return
			
		var dialogue = dialogue_manager.get_dialogue(current_alien.current_dialogue_id)
		if dialogue.has("options"):
			option_1.show()
			option_2.show()
			update_option_symbols(dialogue.options.symbols)
			current_option = 1
			update_option_appearance()
			is_in_alien_zone = true

func end_alien_interaction() -> void:
	is_in_alien_zone = false
	option_1.hide()
	option_2.hide()
	current_alien = null 

func update_option_appearance() -> void:
	option_1.modulate = SELECTED_OPTION if current_option == 1 else UNSELECTED_OPTION
	option_2.modulate = SELECTED_OPTION if current_option == 2 else UNSELECTED_OPTION

func update_option_symbols(symbols: Array) -> void:
	# Update the visual symbols shown in the option bubbles
	if symbols.size() >= 1:
		option_1.get_node("Symbol").texture = preload("res://assets/art/language/yes.png")
	if symbols.size() >= 2:
		option_2.get_node("Symbol").texture = preload("res://assets/art/language/no.png")

func select_current_option() -> void:
	sfx_retroselect.pitch_scale = randf_range(0.8, 1.2)
	sfx_retroselect.play()
	if current_alien:
		current_alien.handle_player_choice(current_option)
	end_alien_interaction()

func _process(_delta: float) -> void:
	# Check for alien interaction
	if is_in_alien_zone:
		if Input.is_action_just_pressed("toggle"):
			sfx_click.pitch_scale = randf_range(0.8, 1.2)
			sfx_click.play()
			current_option = 2 if current_option == 1 else 1
			update_option_appearance()
		
		if Input.is_action_just_pressed("confirm"): 
			select_current_option()
	
	# Check for key presses to fade out tutorial icons
	if w_key.modulate.a > 0 and Input.is_action_just_pressed("w"):
		fade_out_key(w_key)
	if a_key.modulate.a > 0 and Input.is_action_just_pressed("a"):
		fade_out_key(a_key)
	if s_key.modulate.a > 0 and Input.is_action_just_pressed("s"):
		fade_out_key(s_key)
	if d_key.modulate.a > 0 and Input.is_action_just_pressed("d"):
		fade_out_key(d_key)
	
	# Arrow keys
	if up_key.modulate.a > 0 and Input.is_action_just_pressed("ui_up"):
		fade_out_key(up_key)
	if down_key.modulate.a > 0 and Input.is_action_just_pressed("ui_down"):
		fade_out_key(down_key)
	if right_key.modulate.a > 0 and Input.is_action_just_pressed("ui_right"):
		fade_out_key(right_key)
	if left_key.modulate.a > 0 and Input.is_action_just_pressed("ui_left"):
		fade_out_key(left_key)

func fade_out_key(key: TextureRect) -> void:
	var tween = create_tween()
	tween.tween_property(key, "modulate:a", 0.0, KEY_FADE_OUT_DURATION)
