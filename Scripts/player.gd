extends CharacterBody2D

var FRICTION = 15.0
var SPEED = 160.0
var JUMP_VELOCITY = -250.0
var MAX_JUMP_TIME = 0.1

var jump_time = 0.0
var jump_held = -0.1

var setup_anim = 0

var fall_speed = -1.0
var fall_anim = true

var coyote_timer = 0.0

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = 0.0
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
		coyote_timer += delta
		if !Input.is_action_pressed("main_press") and coyote_timer > 0.08:
			jump_time = MAX_JUMP_TIME
	
	# Handle jump.
	if Input.is_action_pressed("main_press"):
		jump_held += delta
		if (jump_held < 0 or jump_time > 0) and jump_time < MAX_JUMP_TIME:
			velocity.y = JUMP_VELOCITY
			jump_time += delta
	else:
		jump_held = -0.1
		
	if Input.is_action_just_released("main_press") and not is_on_floor() and jump_time != MAX_JUMP_TIME:
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
	if !is_on_floor():
		fall_anim = true
		if abs(velocity.x) > 0: $AnimatedSprite2D.flip_h = velocity.x < 0
		if $AnimatedSprite2D.animation != "jump":
			$AnimatedSprite2D.rotation = 0.0
			$AnimatedSprite2D.play("jump")
		elif $AnimatedSprite2D.animation_finished:
			$AnimatedSprite2D.rotation = abs($AnimatedSprite2D.rotation)
			$AnimatedSprite2D.rotation += delta * 0.5
			if $AnimatedSprite2D.flip_h:
				$AnimatedSprite2D.rotation = -$AnimatedSprite2D.rotation
	elif fall_anim:
		$AnimatedSprite2D.rotation = 0.0
		if $AnimatedSprite2D.animation != "end_jump":
			$AnimatedSprite2D.play("end_jump")
			velocity.x *= 0.8
	elif abs(velocity.x) <= 5:
		$AnimatedSprite2D.rotation = 0.0
		if setup_anim == 1:
			$AnimatedSprite2D.play("end_walk")
		else:
			$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.rotation = 0.0
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
	if $AnimatedSprite2D.animation == "end_jump":
		fall_anim = false

func _on_animated_sprite_2d_animation_looped() -> void:
	if $AnimatedSprite2D.animation == "walk":
		$Footstep.play()
