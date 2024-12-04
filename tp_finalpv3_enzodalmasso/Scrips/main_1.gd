extends Node2D

@onready var game_over: Control = $"CanvasLayer/Game Over"
@onready var victoria: Control = $CanvasLayer/Victoria
@onready var area_victoria: Area2D = $AreaVictoria
@onready var player: Player = $Player
@onready var pausa: Control = $CanvasLayer/Pausa



var pause = false

#Esta funcion se utiliza cuando recibe la señal de muerte del player activa la la interfaz de gamover
func _on_player_muerto() -> void:
	game_over.visible=true

#Esta funcion se utiliza cuando el player entra al area activa la la interfaz Victoria
func _on_area_victoria_body_entered(body: Node2D) -> void:
	if body.get_collision_layer() == 2:
		victoria.visible=true
		player.queue_free()
		
	

func _physics_process(delta: float) -> void:
	if pause:
		pausa.visible=true
	else:
		pausa.visible=false
	


func _on_pausa_pausa() -> void:
	pausa.visible=true

