extends Control

@export_file("*.tscn") var main_menu_path: String
var activated = false

func _ready() -> void:
	visible = false

func activate():
	Engine.time_scale = 0
	visible = true
	activated = true
	$VBoxContainer/ResumeButton.grab_focus()

func deactivate():
	Engine.time_scale = 1
	visible = false
	activated = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if activated:
			deactivate()
		else:
			activate()

func _on_resume_button_pressed() -> void:
	deactivate()

func _on_main_menu_button_pressed() -> void:
	deactivate()
	get_tree().change_scene_to_file(main_menu_path)
	

func _on_restart_button_pressed() -> void:
	deactivate()
	get_tree().reload_current_scene()
