extends enemigo_base


func _physics_process(_delta):
	
	if player_ref !=null and perseguir:
		
		direction = player_ref.position-position
		direction= direction.normalized()
		velocity = direction * vel
		update_blend_position()
		move_and_slide()

#Si el player entra dentro del area designada el enemigo lo persigue
func _on_area_2d_body_entered(body):
		if body.get_collision_layer() == 2:
			perseguir = true
			player_ref=body
			set_run(true)

#Si el player sale del area designada desactiva la busqueda del player
func _on_area_2d_body_exited(_body):
		perseguir=false
		player_ref = null
		set_run(false)


  #Funcion para activar animacion de correr y desactiva Idle
func set_run(value):
	animation_tree["parameters/conditions/Run"] = value
	animation_tree["parameters/conditions/Idle"] = not value

#Funcion que se utiliza para generar un ataque al enemigo
func set_swing(value = false):
	animation_tree["parameters/conditions/Swing"] = value

#Funcion que se utiliza para activar la animacion de muerte
func set_dead(value = false):
	animation_tree["parameters/conditions/Dead"] = value

#Funcion que se utiliza cuando el personaje genera una animacion y una vez finalizada quede en la posicion dondo hizo la anim.
func update_blend_position():
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/run/blend_position"] = direction
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/dead/blend_position"] = direction

func danio():
	vida-=1 #Quita 1 de vida al enemigo
	progress_bar.value = vida #Baja la vida en la barra
	if vida == 0: #Si la vida igual a 0
		set_physics_process(false) #Desactiva las fisicas
		set_dead(true)#Activa la animacion de muerte
		set_run(false)#Desactiva la animacion de correr
		set_swing(false)#Desactiva la animacion de ataque
		death_enemy.play()
		await (animation_tree.animation_finished)#Finaliza la animacion de muerte y elimina el cuerpo del enemigo
		queue_free()




#Cuando el Player entra al CuadroColision el enemigo realiza la animacion de ataque y deja de correr
func _on_cuadro_colision_body_entered(body):
	if body is Player:
		perseguir=false
		set_run(false)
		set_swing(true)
		ataque_ogro.play()

#Cuando el Player entra al CuadroColision el enemigo deja de realizar la animacion de ataque y vuelve al estado correr
func _on_cuadro_colision_body_exited(body: Node2D) -> void:
	if body is Player:
		perseguir=true
		set_swing(false)
		$CuadroColision.disable_mode
		set_run(true)



#Funcion para activar la animacion de ataque segun la horientacion
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if !perseguir:
		if anim_name=="attack_left" or anim_name=="attack_right"or anim_name=="attack_up" or anim_name=="attack_down":
			set_swing(true)
	


#Funcion que se utiliza para realizar daño al player
func _on_colision_espada_body_entered(body):
	if body is Player:
		body.danio(3,global_position)
