class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/StartButton 
@onready var tutorial_button = $MarginContainer/HBoxContainer/VBoxContainer/TutorialButton
@onready var credits_button = $MarginContainer/HBoxContainer/VBoxContainer/CreditsButton
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/ExitButton

@onready var star_level = preload("res://Scenes/Main.tscn")

func _ready():
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	credits_button.button_down.connect(on_credits_pressed)
	tutorial_button.button_down.connect(on_controls_pressed)

func on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(star_level)

func on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/controls.tscn")

func on_exit_pressed() -> void:
	get_tree().quit()
