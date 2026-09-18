extends Control

@export var level_tile: PackedScene
@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	for i in LevelManager.level_paths.size():
		var new_level_tile: LevelTile = level_tile.instantiate()
		new_level_tile.level_index = i
		grid_container.add_child(new_level_tile)
