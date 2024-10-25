extends CharacterBody2D
class_name Player

@export var SPEED = 300
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var areaespada: CollisionShape2D = $ColisionEspada/CollisionShape2D

var attack : bool = false
var direction : Vector2 = Vector2.ZERO
@export var vida = 10
@export var fuerza_empuje: int =500



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
 
func set_dead(value = false):
	animation_tree["parameters/conditions/Dead"] = value
	
func update_blend_position():
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/Run/blend_position"] = direction
	animation_tree["parameters/dead/blend_position"] = direction



func _on_colision_espada_body_entered(body):
	if body is enemigo_base:
		body.danio()
	

func danio(danio_enemi: int, pos_enemigo : Vector2):
	
	vida-=danio_enemi
	if vida <= 0:
		set_physics_process(false)
		set_dead(true)
	
	empuje(pos_enemigo)



func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name ==  "dead_up" or anim_name=="dead_down"or anim_name=="dead_right" or anim_name=="dead_left":
		get_parent().remove_child(self)
		queue_free()

func empuje(direccion: Vector2):
	print((global_position-direccion).normalized())
	var dir_empuje = (global_position-direccion).normalized() * fuerza_empuje
	velocity = dir_empuje
	move_and_slide()
	print("checkcccc")
