extends Node3D

var ball = preload("res://Ball.tscn")
var TimingBox 

# Called when the node enters the scene tree for the first time.
func _ready():
	TimingBox = $"Court/Basketball Court/RootNode/RagdollArea/CollisionShape3D"
	$Player.connect("shot_ball", ball_spawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func ball_spawn(timing):
	var ball_instance = ball.instantiate()
	ball_instance.position = $Player.position + Vector3(0, 7, 0)
	ball_instance.go_to_basket()
	handle_timing(timing, ball_instance)
	add_child(ball_instance)
	ball_instance.connect("add_points", update_points)

func update_points(point_value):
	print("+2")
	
func handle_timing(timing, balltp):
	if timing <= 0.3:
		print("Very Early")
		TimingBox.position.y = 0.1
		balltp.target_position.y = 18
		return
	elif timing <= 0.54:
		print("Early")
		TimingBox.position.y = -0.5
		balltp.target_position.y = 20
		return
	elif timing >= 0.55 and timing <= 0.60:
		print("Perfect")
		TimingBox.disabled = true
		return
	elif timing > 0.6 and timing < 0.71:
		print("Late")
		TimingBox.position.y = -0.5
		balltp.target_position.y = 20
		return
	elif timing >= 0.81:
		print("Very Late")
		TimingBox.position.y = 0.1
		balltp.target_position.y = 18
		return
