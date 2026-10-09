extends Camera2D

@onready var player: Node2D = get_tree().get_first_node_in_group("player")
var target_position = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_position = Vector2(player.position.x, player.position.y - 72)
	position = target_position
	$CanvasLayer/PaletteShader.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_position = Vector2(player.position.x + player.velocity.x * 1.0, player.position.y - 72 + player.velocity.y * 0.5)
	position.x += (target_position.x - position.x) * 1.5 * delta
	position.y += (target_position.y - position.y) * 0.8 * delta
	
	$CanvasLayer/PaletteShader.material.set_shader_parameter("world_position", position)
	pass
