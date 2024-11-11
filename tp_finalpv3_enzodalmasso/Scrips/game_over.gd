extends Control

#Funcion para cuando el maouse se presiona recarga la escena nuevamente
func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
