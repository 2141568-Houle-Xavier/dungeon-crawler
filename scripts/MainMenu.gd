extends Control

onready var button = $Panel/TextureButton



func _on_TextureButton_pressed():
	Events.emit_signal("player_pressed_start")
	self.visible = false
