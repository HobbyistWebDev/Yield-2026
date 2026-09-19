extends Control

@export var level_tile: PackedScene
@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	#for i in LevelManager.level_paths.size():
		#var new_level_tile: LevelTile = level_tile.instantiate()
		#new_level_tile.level_index = i
		#grid_container.add_child(new_level_tile)
	
	for b:TextureButton in $GridContainer.get_children():
		b.connect("btn_down", button_pressed)
	
	$GridContainer/Level1.grab_focus()

func button_pressed(id:int):
	LevelManager.go_to_level(id)
