extends CharacterBody2D
class_name Player

@export var SPEED = 300 #Velocidad del player
@onready var animation_tree: AnimationTree = $AnimationTree #variable que se utiliza para las animaciones
@onready var areaespada: CollisionShape2D = $ColisionEspada/CollisionShape2D #Variable para detectar las colisiones de la espada con el cuerpo enemigo
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D #variabiable para acceder a los sprites

var attack : bool = false #Variable para detectar si esta atacando el player
var direction : Vector2 = Vector2.ZERO #Direccion 
@export var vida = 10 #Vida 
@export var fuerza_empuje: int =500 #Variable que se utiliza cuando el Player es golpeado recibe un pequeñp empuje

@onready var timer: Timer = $Timer #Timer que utilizo para activar shaders
@onready var progress_bar: ProgressBar = $ProgressBar #Barra de vida

var material_shader #Variable para shaders
signal muerto #Señal de muerte

@onready var audio_ataque: AudioStreamPlayer = $Sonidos/Ataque
@onready var death_player: AudioStreamPlayer = $Sonidos/DeathPlayer



func _physics_process(_delta):
	if not attack: #Si el personaje no esta atacando
		velocity = direction * SPEED #Aplica movimiento
	else:
		velocity = Vector2.ZERO #Personaje en estado Idle
	move_and_slide()
 
func _process(_delta):
	
	if not attack:#Si el personaje no esta atacando
		direction = Input.get_vector("Left","Right","Up","Down") #Recibe un valor segun la tecla presionada
		if direction != Vector2.ZERO: #Si el personaje esta en movimiento
			set_run(true) #Activa animacion de correr
			update_blend_position()
		else:
			set_run(false)#Desactiva animacion de correr
		
	

#Se utiliza esta funcion para cuando se presiona la tecla Space realiza un ataque
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Attack"):
		attack=true #Ataque es verdadero
		audio_ataque.play()
		set_run(false) 
		set_swing(true)
		areaespada.disabled = false #Desactiva el area de la espada una vez terminada la animacion

#Funcion que se utiliza para generar un ataque al enemigo
func set_swing(value = false):
	
	animation_tree["parameters/conditions/Swing"] = value #Se activa la animacion de ataque
	if value == false: #Si el personaje no esta atacando
		attack = value #Se activa el ataque
		areaespada.disabled = true #Activa el area de la espada una vez Iniciado la animacion
		
	
 
#Funcion que se utiliza para activar la animacion de correr
func set_run(value):
	animation_tree["parameters/conditions/Run"] = value
	animation_tree["parameters/conditions/Idle"] = not value
 
#Funcion que se utiliza para activar la animacion de muerte
func set_dead(value = false):
	animation_tree["parameters/conditions/Dead"] = value

#Funcion que se utiliza cuando el personaje genera una animacion y una vez finalizada quede en la posicion dondo hizo la anim.
func update_blend_position():
	animation_tree["parameters/attack/blend_position"] = direction
	animation_tree["parameters/idle/blend_position"] = direction
	animation_tree["parameters/Run/blend_position"] = direction
	animation_tree["parameters/dead/blend_position"] = direction


#Esta funcion sirve para cuando un la espada colisiona con el enemigo genere daño
func _on_colision_espada_body_entered(body):
	if body is enemigo_base:
		body.danio()
		

#Esta funcion se utiliza para descontarle vida al Player
#Recibe una variable entera y una posicion
func danio(danio_enemi: int, pos_enemigo : Vector2):
	vida-=danio_enemi #Recibe el daño que genera el player y se la quita de la vida
	progress_bar.value = vida #Baja la vida en la barra
	shader_danio() 
	if vida <= 0: #Si la vida es menor igual a 0
		set_physics_process(false) #Desactiva las fisicas
		set_dead(true) #Activa la animacion de muerte
		death_player.play()
		await (animation_tree.animation_finished) #Finaliza la animacion de muerte y emite señal de muerte
		emit_signal("muerto")
	else :
		empuje(pos_enemigo) 
	


#Funcion para activar la animacion de muerte segun la horientacion
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name ==  "dead_up" or anim_name=="dead_down"or anim_name=="dead_right" or anim_name=="dead_left":
		get_parent().remove_child(self)
		queue_free() 
		

#Funcion para generar un empuje cuando el PLayer recibe daño
#Recibe una direccion
func empuje(direccion: Vector2):
		#aplica un movimiento en dirección opuesta al punto direccion, simulando un empuje.
		var dir_empuje = (global_position-direccion).normalized() * fuerza_empuje
		velocity = dir_empuje
		move_and_slide()


#Esta función se utiliza para aplicar un efecto visual con un cierto tiempo cada vez que el personaje recibe daño. 
func shader_danio():
	material_shader= animated_sprite_2d.material
	if material_shader is ShaderMaterial:
		material_shader.set_shader_parameter("active", true)
		timer.start()


#Funcion para desactivar el efecto visual despues de un cierto tiempo
func _on_timer_timeout() -> void:
	material_shader.set_shader_parameter("active", false)
