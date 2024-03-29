extends RigidBody3D 

var initial_position = Vector3(0, 0, 0) # A
var target_position = Vector3(60, 18, -0.2) # B
var control_height = Vector3(0, 0, 0) # C

var shot_speed = 1
var samptime = 0
var shot_height = 0
var point_value = 2

signal add_points

var is_shot = false

func _process(delta):
	if is_shot:
		shot_height = clamp((target_position.x - initial_position.x) + (target_position.z - absf(initial_position.z) * -1), 5, 20)
		if shot_height < 10:
			shot_speed = 2
		else:
			shot_speed = 1
		apply_torque(Vector3(randf_range(-15, 15), randf_range(-15, 15), randf_range(-15, 15)))
		control_height = Vector3((initial_position.x + target_position.x) / 2, ((initial_position.y + target_position.y) / 2) + shot_height, + (initial_position.z + target_position.z) / 2)
		samptime += delta * shot_speed
		position = evaluate(samptime)
	else:
		return


func go_to_basket():
	initial_position = position
	is_shot = true

func evaluate(t):
	var ac = lerp(initial_position, control_height, t) 
	var cb = lerp(control_height, target_position, t) 
	return lerp(ac, cb, t)



func _on_area_3d_area_entered(area):
	if area.name == "RagdollArea":
		is_shot = false
	elif area.name == "PointArea":
		point_value = 2
		point_value = 3
		emit_signal("add_points", point_value)
	elif area.name == "ThreePointerArea":
		pass
	else:
		queue_free()


func _on_body_entered(body):
	is_shot = false
