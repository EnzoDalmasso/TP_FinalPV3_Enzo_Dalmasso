extends CharacterBody2D
class_name enemigo_base

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var cuadro_colision: Area2D = $CuadroColision
@onready var areaespada: CollisionShape2D = $ColisionEspada/CollisionShape2D

@export_range(10,100) var vel: int = 10 
var player = null
var direction = Vector2.ZERO
@export var vida = 1
var attack : bool = false


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
			#set_attack(false)


func _on_area_2d_body_exited(_body):
		player = null
		set_run(false)
		#set_attack(false)


 
func set_run(value):
	animation_tree["parameters/conditions/Run"] = value
	animation_tree["parameters/conditions/Idle"] = not value


func set_swing(value = false):
	attack = value
	animation_tree["parameters/conditions/Swing"] = value
	if value == false:
		areaespada.disabled = true

func update_blend_position():
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/run/blend_position"] = direction
	animation_tree["parameters/attack/blend_position"] = direction

func danio():
	vida-=1
	if vida == 0:
		queue_free()




#Cuando el Player entra al CuadroColision el enemigo realiza el attaque 
func _on_cuadro_colision_body_entered(body):
	if body is player:
		set_swing(true)
		body.danio()


