extends Node2D

@onready var game_over: Control = $"CanvasLayer/Game Over"
@onready var victoria: Control = $CanvasLayer/Victoria
@onready var area_victoria: Area2D = $AreaVictoria
@onready var player: Player = $Player



func _on_player_muerto() -> void:
	game_over.visible=true


func _on_area_victoria_body_entered(body: Node2D) -> void:
	if body.get_collision_layer() == 2:
		victoria.visible=true
		player.queue_free()
		
		
