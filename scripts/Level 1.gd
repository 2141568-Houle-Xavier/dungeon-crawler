extends Node2D

signal level_is_finished()

func _ready():
	Events.connect("change_number_of_enemy", self, "changement_niveau")
	
func changement_niveau(num):
	if num == 0:
		self.emit_signal("level_is_finished")

