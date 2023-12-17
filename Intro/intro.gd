class_name Intro
extends Control

@onready var logo = $ColorRect/MarginContainer/VBoxContainer/Sprite2D/AnimationPlayer

func _ready():
	logo.play("logo")
	await logo.animation_finished
	get_tree().change_scene_to_file("res://Mainmenu/main_menu.tscn")
