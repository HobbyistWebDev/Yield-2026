extends Button
class_name LevelTile

var level_index: int

func _ready() -> void:
	text = str(level_index)
