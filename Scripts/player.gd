extends CharacterBody2D

var FRICTION = 15.0
var SPEED = 160.0
var JUMP_VELOCITY = -250.0
var MAX_JUMP_TIME = 0.1

var jump_time = 0.0
var jump_held = -0.1

var setup_anim = 0

var fall_speed = -1.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		jump_time = 0.0
		FRICTION = 15.0
		if fall_speed > 8:
			$Fall.volume_db = (fall_speed / 30) - 30
			$Fall.play()
			fall_speed = -1.0
	else:
		velocity += get_gravity() * delta
		fall_speed = velocity.y
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
	
	animate(delta)
	move_and_slide()
	
func animate(delta):
	if abs(velocity.x) <= 5:
		if setup_anim == 1:
			$AnimatedSprite2D.play("end_walk")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		if setup_anim == 0:
			$AnimatedSprite2D.play("pre_walk")
		else:
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
		

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "pre_walk":
		setup_anim = 1
	if $AnimatedSprite2D.animation == "end_walk":
		setup_anim = 0

func _on_animated_sprite_2d_animation_looped() -> void:
	if $AnimatedSprite2D.animation == "walk":
		$Footstep.play()
