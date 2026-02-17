extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D

#constant variables
const SPEED := 300.0
const GRAVITY := 1000
const FALL_GRAVITY := 1500

#variables
var JUMP_VELOCITY = -550
var jump_amount = 0


func gravity(velocity: Vector2):
	if velocity.y < 0:
		return GRAVITY
	return FALL_GRAVITY

func _physics_process(delta: float) -> void:
	# Add animation
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "Running"
		if velocity.x > 1:
			animated_sprite_2d.flip_h = false
		else:
			animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.animation = "Idling"
	
	if velocity.y < 0:
		animated_sprite_2d.animation = "Jumping"
	elif velocity.y > 0:
		animated_sprite_2d.animation = "Falling"
	
	if is_on_floor():
		jump_amount = 0
	
	
	# Add the gravity.
	if not is_on_floor() or Input.is_action_just_released("jump"):
		velocity.y += gravity(velocity) * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
	
	if !is_on_floor() and !jump_amount == 2:
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_VELOCITY
				jump_amount += 1
			if Input.is_action_just_released("jump") and velocity.y < 0:
				velocity.y = JUMP_VELOCITY / 4
				jump_amount += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
