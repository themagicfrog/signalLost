extends CharacterBody2D

const SPEED = 700.0
const JUMP_VELOCITY = -500.0
const SPACE_GRAVITY = 980
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"  # Changed to TileMap type
#@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumpEvenIfNotOnGround = true
var jumpWasPressed = false
#var gravity = get_gravity()
var gravityDirection = 1  # Changed default to 1 (downward)

# Add these variables
const GRAVITY_CHECK_DISTANCE = 32  # Adjust based on your tile size

func _physics_process(delta: float) -> void:
	update_gravity_direction()
	
	if is_on_floor():
		jumpEvenIfNotOnGround = true
		if jumpWasPressed == true:
			velocity.y = JUMP_VELOCITY * gravityDirection
	
	if Input.is_action_just_pressed("down"):
		#jumpWasPressed = true
		#rememberJumpTime()
		#if jumpEvenIfNotOnGround == true:
		velocity.y = JUMP_VELOCITY * gravityDirection
	
	if Input.is_action_just_pressed("up"):
		#jumpWasPressed = true
		#rememberJumpTime()
		#if jumpEvenIfNotOnGround == true:
		velocity.y = JUMP_VELOCITY * gravityDirection * -1
	
	if !is_on_floor():
		#coyoteTime()
		velocity.y += SPACE_GRAVITY * delta * gravityDirection
		#b* gravityDirection
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 25)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
func update_gravity_direction() -> void:
	var player_pos = global_position
	var tiles_to_check = [
		Vector2(0, -GRAVITY_CHECK_DISTANCE),  # Above
		Vector2(0, GRAVITY_CHECK_DISTANCE),   # Below
	]
	
	var up_count = 0
	var down_count = 0
	
	for offset in tiles_to_check:
		var check_pos = player_pos + offset
		var tile_pos = tile_map_layer.local_to_map(check_pos)
		var tile_data = tile_map_layer.get_cell_tile_data(tile_pos)
		
		if tile_data:
			var direction = tile_data.get_custom_data("gravity_direction")
			match direction:
				"up":
					up_count += 1
				"down":
					down_count += 1
	
	# Determine gravity direction based on nearby tiles
	if up_count > down_count:
		gravityDirection = -1  # Pull upward
	elif down_count > up_count:
		gravityDirection = 1   # Pull downward
	# If equal counts or no gravity tiles detected, maintain current gravity
	
func coyoteTime():
	await get_tree().create_timer(0.15).timeout
	jumpEvenIfNotOnGround = false
	pass
	
func rememberJumpTime():
	await get_tree().create_timer(0.1).timeout
	jumpWasPressed = false
	pass
