extends CharacterBody2D

@export var SPEED = 300
@onready var animation_tree: AnimationTree = $AnimationTree
var attack : bool = false
var direction : Vector2 = Vector2.ZERO
var vida = 1

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


func set_swing(value = false):
	attack = value
	animation_tree["parameters/conditions/Swing"] = value
 
func set_run(value):
	animation_tree["parameters/conditions/Run"] = value
	animation_tree["parameters/conditions/Idle"] = not value
 
func update_blend_position():
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/Run/blend_position"] = direction
