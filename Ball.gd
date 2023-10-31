extends RigidBody3D  # Use o tipo de corpo adequado para o seu objeto (RigidBody, KinematicBody, etc.)

var initial_position
var target_position

func _ready():
	initial_position = global_transform.origin
	target_position = Vector3(60, 18, -0.2) # Substitua isso pela posição do seu destino

func _process(delta):
	pass

func go_to_basket():
	apply_central_impulse(Vector3(25, 25, 0))

func _on_area_3d_area_entered(area):
	queue_free()
