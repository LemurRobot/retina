extends StaticBody2D

var down_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionPolygon2D.set_deferred("disabled", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_down"):
		down_timer += delta
	else:
		if (down_timer > 0 and down_timer < 0.15):
			down_timer += delta
		else:
			down_timer = 0.0
		
	if (down_timer > 0 and down_timer < 0.15) or down_timer > 0.4:
		$CollisionPolygon2D.set_deferred("disabled", true)
	else:
		$CollisionPolygon2D.set_deferred("disabled", false)
