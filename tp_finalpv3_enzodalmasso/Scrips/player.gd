extends CharacterBody2D
class_name player

@export var SPEED = 300
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var areaespada: CollisionShape2D = $ColisionEspada/CollisionShape2D

var attack : bool = false
var direction : Vector2 = Vector2.ZERO
@export var vida = 10


func _physics_process(_delta):
	if not attack:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
 
func _process(_delta):
	direction = Input.get_vector("Left","Right","Up","Down")
 
	if direction != Vector2.ZERO and not attack:
		set_run(true)
		update_blend_position()
	else:
		set_run(false)
 
	if Input.is_action_just_pressed("Attack"):
		set_swing(true)
		areaespada.disabled = false
		


func set_swing(value = false):
	attack = value
	animation_tree["parameters/conditions/Swing"] = value
	if value == false:
		areaespada.disabled = true
	
 
func set_run(value):
	animation_tree["parameters/conditions/Run"] = value
	animation_tree["parameters/conditions/Idle"] = not value
 
func update_blend_position():
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/Run/blend_position"] = direction




func _on_colision_espada_body_entered(body):
	if body is enemigo_base:
		body.danio()
	

func danio():
	vida-=1
	if vida == 0:
		queue_free()

