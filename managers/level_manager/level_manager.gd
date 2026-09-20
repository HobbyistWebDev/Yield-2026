extends Node

@export_file("*.tscn") var level_paths: Array[String]
var level_records: Array[float]
@export_file("*.tscn") var main_menu_path: String

var current_level = -1

var is_clock_ticking = false
var clock_value: float = 0

func _process(delta: float):
	if is_clock_ticking:
		clock_value += delta

func _ready():
	level_records.resize(level_paths.size())
	level_records.fill(100000)

func bound_check(ind: int):
	return ind >= 0 && ind < level_paths.size()

func go_to_level(ind: int):
	if not bound_check(ind):
		push_warning("Out of bounds Level Manager!")
		return
	SceneTransition.transition(level_paths[ind])
	current_level = ind
	is_clock_ticking = true
	clock_value = 0

func go_to_next_level():
	if level_records[current_level] > clock_value:
		level_records[current_level] = clock_value
	
	if current_level == 3:
		SceneTransition.transition("res://game/win.tscn")
	else:
		#go_to_level(current_level + 1)
		SceneTransition.transition("res://level_select/level_select.tscn")

func go_to_main_menu():
	SceneTransition.transition(main_menu_path)
	current_level = -1
	is_clock_ticking = false

func restart_level(delay=0):
	clock_value = 0
	is_clock_ticking = true
	await  get_tree().create_timer(delay).timeout
	get_tree().reload_current_scene()
