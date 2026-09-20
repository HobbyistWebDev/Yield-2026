extends VBoxContainer

@onready var current_label = $CurrentLabel
@onready var fastest_label = $FastestLabel

func _process(delta: float) -> void:
	var clock_value = LevelManager.clock_value
	var record = LevelManager.level_records[LevelManager.current_level]
	current_label.text = "CURRENT: " + str(int(clock_value))
	if record < 800:
		fastest_label.text = "FASTEST: " + str(int(record))
