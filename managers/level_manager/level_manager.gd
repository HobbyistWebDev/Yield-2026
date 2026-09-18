extends Node

@export_file("*.tscn") var level_paths: Array[String]

func go_to_level(ind: int):
	get_tree().change_scene_to_file(level_paths[ind])
