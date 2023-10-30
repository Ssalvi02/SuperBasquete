extends CharacterBody3D

@export var speed = 15.0
@export var run_speed = 35.0

@export var stamina_consume_rate = 60
@export var stamina_recover_rate = 15
@export var base_stamina = 100
@export var current_stamina = 0

@export var jump_strength = 25

@export var facing = 0
@export var frame = 0
@export var animation_column = 0

@onready var stamina_bar = $StaminaBar3D/SubViewport/Control/TextureProgressBar


func _ready():
	$Animation.play("Movement")
	
	current_stamina = base_stamina
	stamina_bar.max_value = base_stamina
	stamina_bar.value = current_stamina
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	current_stamina = clamp(current_stamina, 0, base_stamina)
	print(current_stamina)
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("shoot") and is_on_floor():
		velocity.y = jump_strength

	if Input.is_action_pressed("run") and current_stamina > 0 and velocity.x != 0 and is_on_floor():
		current_stamina -= stamina_consume_rate * delta
		speed = run_speed
	else:
		current_stamina += stamina_recover_rate * delta
		speed = 15.0
	
	stamina_bar.value = current_stamina
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
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
	if input_dir == Vector2(0,-1):
		facing = 9
	# Face towards camera
	if input_dir == Vector2(0,1):
		facing = 0
	# Face right
	if input_dir == Vector2(1,0):
		facing = 6
	# Face left
	if input_dir == Vector2(-1,0):
		facing = 3
