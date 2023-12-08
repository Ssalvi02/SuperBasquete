class_name Controls
extends Control

@onready var return_button = $MarginContainer/HBoxContainer/VBoxContainer/ReturnButton

func _ready():
	return_button.button_down.connect(on_return_pressed)

func on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Mainmenu/main_menu.tscn")
