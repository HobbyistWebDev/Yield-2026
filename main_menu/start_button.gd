extends TextureButton

@export_file("*.tscn") var level_select_path: String

func _ready():
	grab_focus()

func _on_pressed() -> void:
	AudioManager.play("mini_jump_notify")
	$AnimationPlayer.play("press")
	await($AnimationPlayer.animation_finished)
	#LevelManager.go_to_level(0)
	SceneTransition.transition("res://game/intro.tscn")
