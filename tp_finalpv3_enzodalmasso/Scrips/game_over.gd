extends Control

#Funcion para cuando el maouse se presiona recarga la escena nuevamente
func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_2.tscn")
