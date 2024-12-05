extends Control

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_next_level_pressed() -> void:
	audio_stream_player_2d.play()
	get_tree().change_scene_to_file("res://Scenes/menu_inicial.tscn")

#Funcion para cuando el maouse se presiona recarga la escena nuevamente
func _on_retry_pressed() -> void:
	audio_stream_player_2d.play()
	get_tree().reload_current_scene()
