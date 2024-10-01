extends CharacterBody2D
class_name enemigo_base

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var cuadro_colision: Area2D = $CuadroColision

@export_range(10,100) var vel: int = 10 
var player = null
var direction = Vector2.ZERO
@export var vida = 1

func _physics_process(_delta):
	
	if player !=null:
		direction = player.position-position
		direction= direction.normalized()
		velocity = direction * vel
		update_blend_position()
		move_and_slide()


func _on_area_2d_body_entered(body):
		if body.get_collision_layer() == 2:
			player=body
			set_run(true)
		


func _on_area_2d_body_exited(_body):
		player = null
		set_run(false)
		

 
func set_run(value):
	animation_tree["parameters/conditions/Run"] = value
	animation_tree["parameters/conditions/Idle"] = not value
 
func update_blend_position():
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/run/blend_position"] = direction

func danio():
	vida-=1
	if vida == 0:
		queue_free()





func _on_cuadro_colision_body_entered(body):
	if body is player:
		body.danio()
