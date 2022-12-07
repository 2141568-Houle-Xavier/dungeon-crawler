extends Node

var levels = [preload("res://scenes/Level 1.tscn"), preload("res://scenes/Level 2.tscn")]
var current_level = 0
var current_level_node
var enemies

func load_level():
	current_level_node = levels[current_level].instance()
	current_level_node.connect("level_is_finished", self, "_on_level_finished")
	add_child(current_level_node)
	
	enemies = current_level_node.get_node("Enemies")
	Events.emit_signal("change_number_of_enemy", enemies.get_child_count())

func number_of_enemies_alive_changed():
	enemies = current_level_node.get_node("Enemies")
	Events.emit_signal("change_number_of_enemy", enemies.get_child_count())	
	

func _on_level_finished():
	var next_level = current_level + 1
	if next_level == len(levels): return
	var next_level_node = levels[next_level].instance()
	current_level = next_level
	
	next_level_node.connect("level_is_finished", self, "_on_level_finished")
	current_level_node.queue_free()
	add_child(next_level_node)
	current_level_node = next_level_node
	number_of_enemies_alive_changed()

func restart_game():
	current_level_node.queue_free()
	current_level = 0
	$GUI/StatusBar/ProgressBar.value = $GUI/StatusBar/ProgressBar.max_value
	load_level()

func player_died_function():
	$GUI/DeathMenu.visible = true
	
func _ready():
	Events.connect('player_pressed_start', self, 'load_level')
	Events.connect('player_pressed_restart', self, 'restart_game')
	Events.connect('player_died', self, 'player_died_function')
