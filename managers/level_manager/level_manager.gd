extends Node

@export_file("*.tscn") var level_paths: Array[String]

func go_to_level(ind: int):
	SceneTransition.transition(level_paths[ind])
