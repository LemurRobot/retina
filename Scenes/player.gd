extends CharacterBody2D

var FRICTION = 15.0
var SPEED = 180.0
var JUMP_VELOCITY = -160.0
var MAX_JUMP_TIME = 0.1

var jump_time = 0.0
var jump_held = -0.1

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jump_time = 0.0
		FRICTION = 15.0
	else:
		velocity += get_gravity() * delta
		FRICTION = 7.5
	
	# Handle jump.
	if Input.is_action_pressed("main_press"):
		jump_held += delta
		if (jump_held < 0 or jump_time > 0) and jump_time < MAX_JUMP_TIME:
			velocity.y = JUMP_VELOCITY
			jump_time += delta
	else:
		jump_held = -0.1
		
	if Input.is_action_just_released("ui_accept") and not is_on_floor() and jump_time != MAX_JUMP_TIME:
		jump_time = MAX_JUMP_TIME
		if velocity.y < 0:
			velocity.y *= 0.5
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction: velocity.x += direction * SPEED * FRICTION * delta
	velocity.x -= velocity.x * FRICTION * delta

	move_and_slide()
