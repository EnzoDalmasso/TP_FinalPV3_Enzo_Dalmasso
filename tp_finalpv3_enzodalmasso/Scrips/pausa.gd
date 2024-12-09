extends Control
@onready var sonido_click: AudioStreamPlayer2D = $SonidoClick
var audio = AudioServer.get_bus_index("Master")

signal pausa


func _on_button_pressed() -> void:
	get_tree().paused = false
	sonido_click.play()
	hide()


func _on_button_2_pressed() -> void:
	get_tree().quit()
	sonido_click.play()


func _on_h_scroll_bar_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,value)




func _on_mute_pressed() -> void:
		AudioServer.set_bus_mute(audio, not AudioServer.is_bus_mute(audio))
