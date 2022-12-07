extends KinematicBody2D

export var max_vie = 100
export var vie = 100
export var speed = 10

var is_attacking = false
var is_blocking = false
var invicible = false

var velocity = Vector2.ZERO
var direction = Vector2.ZERO

func _physics_process(_delta):
	movement()
	animation_handler()


func movement():
	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	velocity = direction * speed * 0.2 #0.2 pour réduire la vitesse du personnage
	velocity = move_and_collide(velocity)

# Animations

func handle_attack():
	$Sprite/AnimationPlayer.play("attack")
	speed = 0
	is_attacking = true
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false
		speed = 10
		
	if anim_name == "death":
		Events.emit_signal("player_died")
		
func handle_blocking(button_released):
	if (button_released == false):
		if is_blocking == false:
			$Sprite/AnimationPlayer.play("blocking")
	
		speed = 0
		is_blocking = true
	else:
		speed = 10
		is_blocking = false

func handle_movement():
	if direction != Vector2.ZERO:
		$Sprite/AnimationPlayer.play("running")
	else:
		$Sprite/AnimationPlayer.play("idle")

	if direction.x > 0:
		scale.x = scale.y * 1
		
	if direction.x < 0:
		scale.x = scale.y * -1

func handle_death():	
	$Sprite/AnimationPlayer.play("death")
	speed = 0
	
func animation_handler():	
	if vie == 0:
		handle_death()
		return

	if Input.is_action_just_pressed("ui_attack") && is_blocking == false:
		handle_attack()
	
	if Input.is_action_pressed("ui_block") && is_attacking == false:
		handle_blocking(false)
	
	if Input.is_action_just_released("ui_block"):
		handle_blocking(true)
		
	if is_attacking == false && is_blocking == false:
		handle_movement()

# Player damaged

func damage_animation():
	$InvulnerabilityTimer.start()
	$Sprite/AnimationDamage.play("damage")
	$Sprite/AnimationDamage.queue("flash")

func _set_health(value):
	var prev_vie = vie
	vie = clamp(value, 0, max_vie)
	if vie != prev_vie:
		Events.emit_signal("player_damaged", vie)
			
func damage_player(damage):
	if $InvulnerabilityTimer.is_stopped() && is_blocking == false:
		_set_health(vie - damage)
		damage_animation()
		
func _on_InvulnerabilityTimer_timeout():
	$Sprite/AnimationDamage.play("rest")

# Player Attack

func _on_AttackHitbox_body_entered(body):
	if body.is_in_group("Enemy") and body.has_method("damage_enemy"):
		body.damage_enemy(15)
