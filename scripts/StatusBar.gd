extends Control

onready var progress_bar = $ProgressBar
onready var label = $Label

func _ready():
	Events.connect("player_damaged", self, "_on_Player_damaged")
	Events.connect("change_number_of_enemy", self, "_number_of_enemy_remaining")

func _on_Player_damaged(vie):
	progress_bar.value = vie
	
func _number_of_enemy_remaining(num):
	label.text = "Enemies  Remaining  :  " + str(num )
