extends Area2D

export var damage = 10

func _ready():
	$AnimationPlayer.play("SpikeTrap")
	
func _on_Spike_body_entered(body):
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		if body.has_method("damage_player"):
			body.damage_player(damage)
		if body.has_method("damage_enemy"):
			body.damage_enemy(damage)
