extends TextureButton

@export_file("*.tscn") var level_select_path: String

func _ready():
	grab_focus()

func _on_pressed() -> void:
	$AnimationPlayer.play("press")
	await($AnimationPlayer.animation_finished)
	SceneTransition.transition(level_select_path)
