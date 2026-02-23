extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var unlock: Node2D = $Unlock
@onready var dash_cool: Timer = $"Dash Cooldown"

#states
var player_dead = false

#movement variables
const SPEED := 450.0

#gravity variables
const GRAVITY := 1500
const FALL_GRAVITY := 1500

#jump variables
var JUMP_VELOCITY := -900
var jump_amount := 0
var has_unlocked_jump = false
var is_double_jump = false

#dash variables
const DASH_SPEED := 1000.0
var has_unlocked_dash = false
var dashing = false
var can_dash = true

#wall jump variables
const WALL_JUMP_PUSHBACK = 100
var has_unlocked_wall = false


func gravity(velocity: Vector2):
	if velocity.y < 0:
		return GRAVITY
	return FALL_GRAVITY

func _physics_process(delta: float) -> void:
	# Updates Abilities
	has_unlocked_dash = GameManager.unlock_dash
	has_unlocked_wall = GameManager.unlock_wall
	has_unlocked_jump = GameManager.unlock_jump
	player_dead = GameManager.is_player_dead
	
	# Add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "Running"
		if velocity.x > 1:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.animation = "Idling"
	
	if velocity.y < 0 and !is_double_jump:
		animated_sprite_2d.animation = "Jumping"
	elif velocity.y < 0 and is_double_jump and !is_on_wall():
		animated_sprite_2d.animation = "DoubleJumping"
	elif velocity.y > 0:
		animated_sprite_2d.animation = "Falling"
	
	if is_on_floor():
		jump_amount = 0
		is_double_jump = false
	
	elif is_on_wall():
		can_dash = true
	
	# Add the gravity.
	if not is_on_floor() or Input.is_action_just_released("jump"):
		velocity.y += gravity(velocity) * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_VELOCITY
	elif !is_on_floor() and is_on_wall() and Input.is_action_pressed("right") and has_unlocked_wall:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.animation = "WallJump"
		velocity.x = -WALL_JUMP_PUSHBACK
		jump_amount = 0
		if Input.is_action_just_pressed("jump"):
			jump_sound.play()
			velocity.y = JUMP_VELOCITY
			jump_amount += 1
		if Input.is_action_just_released("jump") and velocity.y < 0:
			jump_sound.play()
			velocity.y = JUMP_VELOCITY / 4
			jump_amount += 1
	elif !is_on_floor() and is_on_wall() and Input.is_action_pressed("left") and has_unlocked_wall:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.animation = "WallJump"
		velocity.x = WALL_JUMP_PUSHBACK
		jump_amount = 0
		if Input.is_action_just_pressed("jump"):
			jump_sound.play()
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_released("jump") and velocity.y < 0:
			jump_sound.play()
			velocity.y = JUMP_VELOCITY / 4
	
	elif Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
	
	elif !is_on_floor() and !jump_amount == 1 and !is_on_wall() and has_unlocked_jump:
			if Input.is_action_just_pressed("jump"):
				jump_sound.play()
				is_double_jump = true
				velocity.y = JUMP_VELOCITY
				jump_amount += 1
			if Input.is_action_just_released("jump") and velocity.y < 0:
				jump_sound.play()
				is_double_jump = true
				velocity.y = JUMP_VELOCITY / 4
				jump_amount += 1

	#Handles Dashing
	if Input.is_action_just_pressed("dash") and can_dash and has_unlocked_dash:
		animated_sprite_2d.animation = "Dashing" 
		can_dash = false
		dashing = true
		$"Dash Timer".start()
		dash_cool.start()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		if dashing:
			velocity.x = direction * DASH_SPEED
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if player_dead:
		set_physics_process(false)
		death_sound.play()
		animated_sprite_2d.animation = "Hit"
	else:
		set_physics_process(true)
	
	if Input.is_action_just_pressed("menu"):
		GameManager.menu_open = true
	
	move_and_slide()

func _on_dash_timer_timeout() -> void:
	dashing = false


func _on_dash_cooldown_timeout() -> void:
	can_dash = true
