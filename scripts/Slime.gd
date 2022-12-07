extends KinematicBody2D

export var speed = 0.5
export var vie = 50
export var max_vie = 100

var direction = Vector2.ZERO

var is_attacking = false

var player = null

func _physics_process(_delta):
	slime_movement()
	animation_handler()


func _on_PlayerDetection_body_entered(body):
	if body.is_in_group("Player"):
		player = body


func _on_PlayerDetection_body_exited(body):
	if body.is_in_group("Player"):
		player = null
	
func slime_movement():
	direction = Vector2.ZERO
	
	if player:
		direction = position.direction_to(player.position) * speed
	move_and_collide(direction)

func change_slime_face_direction():
	if direction.x < 0:
		scale.x = scale.y * 1
		
	if direction.x > 0:
		scale.x = scale.y * -1

func animation_handler():
	if vie <= 0:
		$Sprite/AnimationPlayer.play("death")
		speed = 0
		return
	
	change_slime_face_direction()
	
	if is_attacking == false:
		if direction != Vector2.ZERO:
			$Sprite/AnimationPlayer.play("idle")
		else:
			$Sprite/AnimationPlayer.stop()



# Slime Get Damage

func damage_animation():
	$InvulnerabilityTimer.start()
	$Sprite/AnimationDamage.play("damage")
	$Sprite/AnimationDamage.queue("flash")

func _on_InvulnerabilityTimer_timeout():
	$Sprite/AnimationDamage.play("rest")

func damage_enemy(ammount):
	if $InvulnerabilityTimer.is_stopped():
		_set_health(vie - ammount)
		damage_animation()

func _set_health(value):
	vie = clamp(value, 0, max_vie)


# Slime Attack

func handle_attack(is_finished):
	if is_finished == false:
		speed = 0
		is_attacking = true
		$Sprite/AnimationPlayer.play("attack")
	else:
		speed = 0.5
		is_attacking = false
	
func _on_AttackDetection_body_entered(body):
	if body.is_in_group("Player"):
		handle_attack(false)
	
func _on_AttackHitbox_body_entered(body):
	if body.is_in_group("Player") and body.has_method("damage_player"):
		body.damage_player(20)
		
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		handle_attack(true)
	if anim_name == "death":
		queue_free()
		Events.emit_signal("change_number_of_enemy", get_parent().get_child_count() - 1)

