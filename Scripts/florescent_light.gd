extends Node2D
@onready var player: Node2D = get_tree().get_first_node_in_group("player")
var flicker_timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PointLight2D.energy = 0.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flicker_timer -= delta
	if flicker_timer < 0.0:
		flicker_timer = randf_range(0.05, 0.1)
		if (player.position - position).length() < 220.0 and player.position.y > position.y:
			var length = (player.position - position).length()
			if randf_range(0, length / 4) < sqrt(length / 4) + 25:
				$PointLight2D.energy = randf_range(1.55, 1.65)
			else:
				$PointLight2D.energy = 0.0
		else:
			$PointLight2D.energy = 0.0
