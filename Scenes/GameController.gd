extends Node3D

var ball = preload("res://Ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.connect("shot_ball", ball_spawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func ball_spawn():
	print("SHOOT")
	var ball_instance = ball.instantiate()
	ball_instance.position = $Player.position + Vector3(0, 7, 0)
	ball_instance.go_to_basket()
	add_child(ball_instance)
