extends Button
class_name LevelTile

var level_index: int

func _ready() -> void:
	text = str(level_index)


func _on_pressed() -> void:
	LevelManager.go_to_level(level_index)
