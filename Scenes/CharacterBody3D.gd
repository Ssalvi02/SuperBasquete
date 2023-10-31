extends CharacterBody3D

@export var speed = 15.0
@export var run_speed = 35.0
@export var friction = 3

@export var stamina_consume_rate = 60
@export var stamina_recover_rate = 15
@export var base_stamina = 100
@export var current_stamina = 0

@export var jump_strength = 25
@export var shoot_timing = 0
var is_with_ball = false
signal shot_ball

@export var facing = 0
@export var frame = 0
@export var animation_column = 0

@onready var stamina_bar = $StaminaBar3D/SubViewport/Control/TextureProgressBar
var ball = preload("res://Ball.tscn")
var ball_instance = ball.instantiate()


func _ready():
	$Animation.play("Movement")
	
	current_stamina = base_stamina
	stamina_bar.max_value = base_stamina
	stamina_bar.value = current_stamina
	stamina_bar.visible = false
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	current_stamina = clamp(current_stamina, 0, base_stamina)
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Pulo
	if Input.is_action_just_pressed("shoot") and is_on_floor():
		velocity.y = jump_strength
		
	# Shooting
	if Input.is_action_pressed("shoot") and is_with_ball:
		shoot_timing += delta
		if shoot_timing > 1.1:
			shoot_timing = 0
			is_with_ball = false
			shot_ball.emit()
			remove_child(ball_instance)
			
		
	if Input.is_action_just_released("shoot") and is_with_ball:
		shoot_timing = 0
		#Spawn da bola
		is_with_ball = false
		shot_ball.emit()
		remove_child(ball_instance)

	if shoot_timing >= 0.55 and shoot_timing <= 0.65:
		$PlayerSprite.modulate = Color.CHARTREUSE
	else:
		$PlayerSprite.modulate = Color.WHITE
		
	# Corrida
	if Input.is_action_pressed("run") and current_stamina > 0 and (velocity.x != 0 or velocity.z != 0) and is_on_floor():
		current_stamina -= stamina_consume_rate * delta
		speed = run_speed
		stamina_bar.visible = true
	else:
		current_stamina += stamina_recover_rate * delta
		speed = 15.0
	
	stamina_bar.value = current_stamina
	
	if(stamina_bar.value >= base_stamina):
		stamina_bar.visible = false
	
	# Pega direção do movimento
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction and is_on_floor():
		velocity.x = direction.x * speed 
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		velocity.z = move_toward(velocity.z, 0, friction)
	
	# Call animation helpers
	update_facing(input_dir)
	if velocity != Vector3(0, 0, 0):
		$Animation.play("Movement")

	update_animation_row()
	
	move_and_slide()
	
	
func update_animation():
	$PlayerSprite.frame = animation_column * 8 + facing

func update_animation_row():
	$PlayerSprite.frame = animation_column + facing 


func update_facing(input_dir):
	# Face away from camera
	if input_dir == Vector2(0,-1) and is_on_floor():
		facing = 9
	# Face towards camera
	if input_dir == Vector2(0,1) and is_on_floor():
		facing = 0
	# Face right
	if input_dir == Vector2(1,0) and is_on_floor():
		facing = 6
	# Face left
	if input_dir == Vector2(-1,0) and is_on_floor():
		facing = 3


func _on_player_area_3d_area_entered(area):
	if area.name == "BallArea3D":
		is_with_ball = true
		ball_instance.get_child(2).set_monitorable(false)
		ball_instance.get_child(2).set_monitoring(false)
		ball_instance.position = Vector3(2,0,2)
		add_child(ball_instance)
