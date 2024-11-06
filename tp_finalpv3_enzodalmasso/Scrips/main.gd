extends Node2D
@onready var game_over: Control = $"Game Over"
@onready var victoria: Control = $Victoria


func _on_player_muerto() -> void:
	game_over.visible=true



func _on_area_victoria_body_entered(body: Node2D) -> void:
	if body.get_collision_layer() == 2:
		victoria.visible=true
