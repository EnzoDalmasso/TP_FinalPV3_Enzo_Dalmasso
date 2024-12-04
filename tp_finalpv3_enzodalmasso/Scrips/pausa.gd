extends Control

signal pausa

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pausa"):
		get_tree().paused = not get_tree().paused
		emit_signal("pausa")


func _on_button_pressed() -> void:
	get_tree().paused = not get_tree().paused


func _on_button_2_pressed() -> void:
	get_tree().quit()
