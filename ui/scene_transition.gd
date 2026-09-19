extends Control

func _ready():
	hide()

func transition(destination:String):
	$AnimationPlayer.play("wipe_out")
	show()
	await($AnimationPlayer.animation_finished)
	get_tree().change_scene_to_file(destination)
	$AnimationPlayer.play("wipe_in")
	await($AnimationPlayer.animation_finished)
	hide()
