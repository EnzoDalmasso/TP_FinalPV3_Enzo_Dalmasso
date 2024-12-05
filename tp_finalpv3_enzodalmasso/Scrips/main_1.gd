extends Node2D

@onready var game_over: Control = $"CanvasLayer/Game Over"
@onready var victoria: Control = $CanvasLayer/Victoria
@onready var area_victoria: Area2D = $AreaVictoria
@onready var player: Player = $Player
@onready var pausa: Control = $CanvasLayer/Pausa
@onready var sonido_victoria: AudioStreamPlayer = $SonidoVictoria
@onready var sonido_derrota: AudioStreamPlayer = $SonidoDerrota
@onready var musica_fondo: AudioStreamPlayer = $"Musica Fondo"

var pause = false

#Esta funcion se utiliza cuando recibe la señal de muerte del player activa la la interfaz de gamover
func _on_player_muerto() -> void:
	sonido_derrota.play()
	game_over.visible=true

#Esta funcion se utiliza cuando el player entra al area activa la la interfaz Victoria
func _on_area_victoria_body_entered(body: Node2D) -> void:
	if body.get_collision_layer() == 2:
		sonido_victoria.play()
		victoria.visible=true
		player.queue_free()
		
	

func _ready() -> void:
	#Inicia el juego e inicia la musica de fondo con su volumen designado
	musica_fondo.play()
	musica_fondo.volume_db = -10

#funcion que se utiliza para llamar a la interfaz de menu de pausa
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pausa"):
		_on_pausa_pausa()


func _on_pausa_pausa() -> void:
	
	pausa.show()
	get_tree().paused=true
	


