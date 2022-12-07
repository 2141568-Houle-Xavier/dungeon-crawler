extends Control

func _on_TextureButton_pressed():
	Events.emit_signal("player_pressed_restart")
	self.visible = false
	
