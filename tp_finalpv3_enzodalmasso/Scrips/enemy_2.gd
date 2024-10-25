extends enemigo_base


func _physics_process(_delta):
	
	if player_ref !=null and perseguir:
		
		direction = player_ref.position-position
		direction= direction.normalized()
		velocity = direction * vel
		update_blend_position()
		move_and_slide()


func _on_area_2d_body_entered(body):
		if body.get_collision_layer() == 2:
			perseguir = true
			player_ref=body
			set_run(true)


func _on_area_2d_body_exited(_body):
		perseguir=false
		player_ref = null
		set_run(false)


 
func set_run(value):
	animation_tree["parameters/conditions/Run"] = value
	animation_tree["parameters/conditions/Idle"] = not value
	#print("corre perra correee: ", value)


func set_swing(value = false):
	animation_tree["parameters/conditions/Swing"] = value

func set_dead(value = false):
	animation_tree["parameters/conditions/Dead"] = value

func update_blend_position():
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/run/blend_position"] = direction
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/dead/blend_position"] = direction

func danio():
	vida-=2
	if vida == 0:
		set_physics_process(false)
		set_dead(true)
		set_run(false)
		set_swing(false)
		await (animation_tree.animation_finished)
		queue_free()




#Cuando el Player entra al CuadroColision el enemigo realiza la animacion de ataque y deja de correr
func _on_cuadro_colision_body_entered(body):
	if body is Player:
		perseguir=false
		set_run(false)
		set_swing(true)
		

#Cuando el Player entra al CuadroColision el enemigo deja de realizar la animacion de ataque y vuelve al estado correr
func _on_cuadro_colision_body_exited(body: Node2D) -> void:
	if body is Player:
		perseguir=true
		set_swing(false)
		set_run(true)



func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if !perseguir:
		if anim_name=="attack_left" or anim_name=="attack_right"or anim_name=="attack_up" or anim_name=="attack_down":
			set_swing(true)
	



func _on_colision_espada_body_entered(body):
	if body is Player:
		body.danio(3,global_position)
