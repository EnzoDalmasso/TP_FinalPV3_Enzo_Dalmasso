extends Control



func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main1.tscn")


func _on_opciones_pressed() -> void:
	pass # Replace with function body.


func _on_salir_pressed() -> void:
	get_tree().quit()
