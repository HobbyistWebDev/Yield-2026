extends Control

func _ready():
	$MainMenuButton.grab_focus()

func _on_main_menu_button_pressed() -> void:
	SceneTransition.transition("res://main_menu/main_menu.tscn")
