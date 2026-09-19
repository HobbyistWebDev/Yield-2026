extends Node

@export_file("*.tscn") var level_paths: Array[String]
@export_file("*.tscn") var main_menu_path: String

var current_level = -1

func bound_check(ind: int):
	return ind >= 0 && ind < level_paths.size()

func go_to_level(ind: int):
	if not bound_check(ind):
		push_warning("Out of bounds Level Manager!")
		return
	SceneTransition.transition(level_paths[ind])
	current_level = ind

func go_to_next_level():
	go_to_level(current_level + 1)

func go_to_main_menu():
	SceneTransition.transition(main_menu_path)
	current_level = -1

func restart_level(delay=0):
	await  get_tree().create_timer(delay).timeout
	get_tree().reload_current_scene()
