extends Node2D

@export var messages:Array[String]
@onready var camera:Camera2D = get_tree().get_first_node_in_group("camera")

func _ready():
	start_tutorial()

func _process(_delta: float) -> void:
	$InfoBox.position = camera.get_screen_center_position() - Vector2(450, 450)

func start_tutorial():
	await($Check1.body_entered)
	$InfoBox/InfoLabel.text = messages[0]
	$InfoBox/AnimationPlayer.play("in")
	
	await($Check2.body_entered)
	$InfoBox/AnimationPlayer.play("out")
	await($InfoBox/AnimationPlayer.animation_finished)
	$InfoBox/InfoLabel.text = messages[1]
	$InfoBox/AnimationPlayer.play("in")
	
	await($Check3.body_entered)
	$InfoBox/AnimationPlayer.play("out")
	await($InfoBox/AnimationPlayer.animation_finished)
	$InfoBox/InfoLabel.text = messages[2]
	$InfoBox/AnimationPlayer.play("in")
	
	await($Check4.body_entered)
	$InfoBox/AnimationPlayer.play("out")
	await($InfoBox/AnimationPlayer.animation_finished)
	$InfoBox/InfoLabel.text = messages[3]
	$InfoBox/AnimationPlayer.play("in")
