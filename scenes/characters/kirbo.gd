extends CharacterBody2D

#main variables

var speed = 800
var jump_speed = 1100
var gravity = 3000
@onready var anim = $Sprite
var is_facing_right = true
var is_player_1 = true
var jump = "jump"
var up = "up"
var left = "left"
var right = "right"
var down = "down"
var attack = "attack"
var special = "special"
var fend = "fend"
var move = "move"
var direction = 0
var facing_dir = 0
var is_attacking = false
var is_colliding_with_the_border = false
var dead_sfx_playerd = false
var dead_delay = 0
var damage_time = 0
var basic_attack_dur = 15
var basic_attack_time = basic_attack_dur
var basic_attack_toggle = 0
var toggle_return_delay = 0
var up_attack_dur = 15
var up_attack_time = up_attack_dur
var down_attack_dur = 15
var down_attack_time = 0
var float_anim_time = 0
var float_jumps = 0
var up_attack_air_dur = 20
var up_attack_air_time = up_attack_air_dur
var up_attack_used = false
var up_attack_air_dura = 15
var up_attack_air_timer = up_attack_air_dura
var down_attack_air_dur = 15
var down_attack_air_time = down_attack_air_dur
var down_special_air_dur = 15
var down_special_air_time = down_special_air_dur
var fend_dur = 20
var fend_time = fend_dur
var acumulated_damage = 0
var dash_attack_dur = 34
var dash_attack_time = dash_attack_dur
var dash_speed = 1500
var Christendom = 0
var light_time = 0


enum states {
	idle,
	run,
	jump,
	damage,
	basic_attack,
	up_attack,
	down_attack,
	floating,
	up_special_air,
	warp_star,
	up_attack_air,
	down_attack_air,
	special,
	down_special_air,
	dash,
	fend,
}

var current_state : states = states.idle

func _ready() -> void:
	if Global.Player_1_Char == "Kirbo" or Global.Player_2_Char == "Kirbo":
		if Global.Player_1_Char == "Kirbo":
			is_player_1 = true
			position = Global.Player_1_start_pos
		else:
			is_player_1 = false
			position = Global.Player_2_start_pos
	else:
		queue_free()

func _physics_process(delta: float) -> void:
	#basics diretional variables
	if not is_attacking:
		direction = Input.get_axis(left, right)
		facing_dir = $Hitbox.scale.x
	
	#change_direction
	if ((is_facing_right and direction < 0) or (not is_facing_right and direction > 0)) and not is_attacking:
		$Hitbox.scale.x *= -1
		$Sprite.scale.x *= -1
		$front.scale.x *= -1
		is_facing_right = not is_facing_right
	
	#change input when is player 2
	if is_player_1:
		jump = "jump"
		up = "up"
		left = "left"
		right = "right"
		down = "down"
		attack = "attack"
		special = "special"
		fend = "fend"
		move = "move"
	else:
		jump = "jump p2"
		up = "up p2"
		left = "left p2"
		right = "right p2"
		down = "down p2"
		attack = "attack p2"
		special = "special p2"
		fend = "fend p2"
		move = "move p2"
	
	
	#the long states part
	
	match current_state:
		states.idle:
			velocity.x = move_toward(velocity.x, 0, 90)
			anim.play("idle")
			if Input.is_action_pressed(move):
				current_state = states.run
			if Input.is_action_just_pressed(jump):
				current_state = states.jump
				velocity.y = -jump_speed
				$Jump.play()
			
			if Input.is_action_just_pressed(fend):
				current_state = states.fend
				fend_time = fend_dur
				$Fart.play()
			
			if Input.is_action_just_pressed(attack):
				if not Input.is_action_pressed(up):
					if not Input.is_action_pressed(down):
						current_state = states.basic_attack
						basic_attack_time = basic_attack_dur
						if not basic_attack_toggle == 2:
							if randi_range(1,2) == 1:
								$"Punch 1".play()
							else:
								if randi_range(1,2) == 1:
									$"Punch 2".play()
								else:
									$"Punch 3".play()
						else:
							$Slap.play()
					else:
						if randi_range(1,2) == 1:
							$"Punch 1".play()
						else:
							if randi_range(1,2) == 1:
								$"Punch 2".play()
							else:
								$"Punch 3".play()
						current_state = states.down_attack
						down_attack_time = down_attack_dur
				else:
					if randi_range(1,2) == 1:
						$"Punch 1".play()
					else:
						if randi_range(1,2) == 1:
							$"Punch 2".play()
						else:
							$"Punch 3".play()
					current_state = states.up_attack
					up_attack_time = up_attack_dur
			if not is_on_floor():
				current_state = states.jump
			
			if Input.is_action_pressed(special):
				if Christendom < 100:
					current_state = states.warp_star
					$Fart.play()
				else:
					if Input.is_action_pressed(up):
						$Explosion.play()
						if is_player_1:
							Global.Player_2_lives -= 1
						else:
							Global.Player_1_lives -= 1
						light_time = 10
						Christendom = 0
					else:
						current_state = states.warp_star
						$Fart.play()
			
		states.run:
			velocity.x = move_toward(velocity.x, direction * speed, 90)
			anim.play("run")
			if not Input.is_action_pressed(move):
				current_state = states.idle
			if Input.is_action_just_pressed(jump):
				current_state = states.jump
				velocity.y = -jump_speed
				$Jump.play()
			
			if Input.is_action_just_pressed(attack):
				current_state = states.dash
				velocity.x = facing_dir * dash_speed
				dash_attack_time = dash_attack_dur
				velocity.y = -500
				$Fart.play()
			
			if Input.is_action_pressed(special):
				current_state = states.warp_star
				$Fart.play()
			
			if not is_on_floor():
				current_state = states.jump
			
			if Input.is_action_just_pressed(fend):
				current_state = states.fend
				fend_time = fend_dur
				$Fart.play()
			
		states.jump:
			velocity.x = move_toward(velocity.x, direction * speed, 25)
			if velocity.y > 0:
				anim.play("fall")
			else:
				anim.play("jump")
			if is_on_floor():
				up_attack_used = false
				if Input.is_action_pressed(move):
					current_state = states.run
				else:
					current_state = states.idle
			
			if Input.is_action_just_released(jump):
				velocity.y *= 0.4
	
			if Input.is_action_just_pressed(attack):
				if not Input.is_action_pressed(move):
					if Input.is_action_pressed(up):
						current_state = states.up_attack_air
						up_attack_air_timer = up_attack_air_dura
						if randi_range(1,2) == 1:
							$"Punch 1".play()
						else:
							if randi_range(1,2) == 1:
								$"Punch 2".play()
							else:
								$"Punch 3".play()
					elif Input.is_action_pressed(down):
						current_state = states.down_attack_air
						down_attack_air_time = down_attack_air_dur
						if randi_range(1,2) == 1:
							$"Punch 1".play()
						else:
							if randi_range(1,2) == 1:
								$"Punch 2".play()
							else:
								$"Punch 3".play()
					else:
						current_state = states.basic_attack
						basic_attack_time = basic_attack_dur
						if not basic_attack_toggle == 2:
							if randi_range(1,2) == 1:
								$"Punch 1".play()
							else:
								if randi_range(1,2) == 1:
									$"Punch 2".play()
								else:
									$"Punch 3".play()
						else:
							$Slap.play()
				else:
					current_state = states.dash
					velocity.x = facing_dir * dash_speed
					dash_attack_time = dash_attack_dur
					velocity.y = -500
					$Fart.play()
			
			if Input.is_action_just_pressed(special) and Input.is_action_pressed(up) and not up_attack_used and not Input.is_action_pressed(down):
				$Fart.play()
				current_state = states.up_special_air
				up_attack_air_time = up_attack_air_dur
				up_attack_used = true
				velocity.y = 0
			
			if Input.is_action_just_pressed(special) and Input.is_action_pressed(down) and not Input.is_action_pressed(up):
				$Sword.play()
				current_state = states.down_special_air
				down_special_air_time = down_special_air_dur
				velocity.y = 0
			
			if Input.is_action_just_pressed(jump):
				velocity.y = -1000
				current_state = states.floating
				$float.play()
			
		states.damage:
			velocity.x = move_toward(velocity.x, 0, 5)
			anim.play("damage")
			if is_on_floor():
				current_state = states.idle
			if damage_time > 0:
				damage_time -= 1
			else:
				current_state = states.jump
			gravity = 3000
		
		states.basic_attack:
			velocity.y = -50
			if is_on_floor():
				velocity.x = move_toward(velocity.x, direction * 50, 90)
			else:
				velocity.x = move_toward(velocity.x, direction * 50, 25)
			
			if basic_attack_toggle == 0:
				anim.play("punch 1")
			elif basic_attack_toggle == 1:
				anim.play("punch 2")
			else:
				anim.play("punch 3")
			if basic_attack_time > 0:
				basic_attack_time -= 1
				if $front.is_colliding():
					is_attacking = true
			else:
				is_attacking = false
				if is_on_floor():
					if not Input.is_action_pressed(move):
						current_state = states.idle
					else:
						current_state = states.run
				else:
					current_state = states.jump
				if basic_attack_toggle < 1:
					basic_attack_toggle += 1
				else:
					basic_attack_toggle = 0
		states.up_attack:
			anim.play("up_attack")
			velocity.x = move_toward(velocity.x, 0, 90)
			if up_attack_time > 0:
				up_attack_time -= 1
				if $up.is_colliding():
					is_attacking = true
			else:
				current_state = states.idle
				is_attacking = false
		states.down_attack:
			anim.play("down_attack")
			velocity.x = move_toward(velocity.x, 0, 90)
			if down_attack_time > 0:
				down_attack_time -= 1
				if $down.is_colliding():
					is_attacking = true
			else:
				current_state = states.idle
				is_attacking = false
		states.floating:
			velocity.x = move_toward(velocity.x, direction * speed, 30)
			if float_anim_time == 0:
				anim.play("floating")
			else:
				anim.play("floating_impulse")
			
			if Input.is_action_just_pressed(jump) and float_anim_time == 0 and float_jumps < 5:
				velocity.y = -1000
				float_anim_time = 5
				float_jumps += 1
				$float.play()
			if float_anim_time > 0:
				float_anim_time -= 1
			
			if is_on_floor():
				current_state = states.idle
				float_jumps = 0
				up_attack_used = false
			
			if Input.is_action_pressed(down):
				current_state = states.jump
			
			if Input.is_action_just_pressed(special) and Input.is_action_pressed(up) and not up_attack_used:
				$Fart.play()
				current_state = states.up_special_air
				up_attack_air_time = up_attack_air_dur
				up_attack_used = true
				velocity.y = 0
			
			if Input.is_action_just_pressed(attack):
				if not Input.is_action_pressed(move):
					if Input.is_action_pressed(up):
						current_state = states.up_attack_air
						up_attack_air_timer = up_attack_air_dura
						if randi_range(1,2) == 1:
							$"Punch 1".play()
						else:
							if randi_range(1,2) == 1:
								$"Punch 2".play()
							else:
								$"Punch 3".play()
					elif Input.is_action_pressed(down):
						current_state = states.down_attack_air
						down_attack_air_time = down_attack_air_dur
						if randi_range(1,2) == 1:
							$"Punch 1".play()
						else:
							if randi_range(1,2) == 1:
								$"Punch 2".play()
							else:
								$"Punch 3".play()
					else:
						current_state = states.basic_attack
						basic_attack_time = basic_attack_dur
						if not basic_attack_toggle == 2:
							if randi_range(1,2) == 1:
								$"Punch 1".play()
							else:
								if randi_range(1,2) == 1:
									$"Punch 2".play()
								else:
									$"Punch 3".play()
						else:
							$Slap.play()
				else:
					current_state = states.dash
					velocity.x = facing_dir * dash_speed
					dash_attack_time = dash_attack_dur
					velocity.y = -500
					$Fart.play()
			
			if Input.is_action_just_pressed(special) and Input.is_action_pressed(down) and not Input.is_action_pressed(up):
				$Sword.play()
				current_state = states.down_special_air
				down_special_air_time = down_special_air_dur
				velocity.y = 0
			
		states.down_attack_air:
			gravity = 0
			anim.play("down_attack_air")
			if down_attack_air_time > 0:
				down_attack_air_time -= 1
				if $down.is_colliding():
					is_attacking = true
				if $front.is_colliding():
					is_attacking = true
			else:
				current_state = states.jump
				is_attacking = false
				gravity = 3000
				up_attack_air_time = up_attack_air_dur
		
		states.up_attack_air:
			gravity = 0
			anim.play("up_air_attack")
			if up_attack_air_time > 0:
				up_attack_air_time -= 1
				if $up.is_colliding():
					is_attacking = true
				if $front.is_colliding():
					is_attacking = true
			else:
				current_state = states.jump
				is_attacking = false
				gravity = 3000
		
		states.up_special_air:
			$warp_star.play()
			anim.play("up_air_special")
			velocity.y = move_toward(velocity.y, -1000, 100)
			velocity.x = move_toward(velocity.x, facing_dir * 100, 15)
			if up_attack_air_time > 0:
				up_attack_air_time -= 1
				if $back.is_colliding():
					is_attacking = true
				if $front.is_colliding():
					is_attacking = true
				if $up.is_colliding():
					is_attacking = true
				if $down.is_colliding():
					is_attacking = true
			else:
				current_state = states.jump
			
		
		states.down_special_air:
			anim.play("down_special_air")
			gravity = 10
			if down_special_air_time > 0:
				down_special_air_time -= 1
				if $down.is_colliding():
					is_attacking = true
				if $front.is_colliding():
					is_attacking = true
			else:
				current_state = states.jump
				is_attacking = false
				gravity = 3000
		
		states.dash:
			anim.play("dash")
			$warp_star.play()
			if dash_attack_time > 0:
				dash_attack_time -= 1
				if $front.is_colliding():
					is_attacking = true
			else:
				if not is_on_floor():
					current_state = states.jump
				else:
					current_state = states.run
				is_attacking = false
		
		states.warp_star:
			anim.play("warp_star")
			$warp_star.play()
			velocity.x = move_toward(velocity.x, direction * 700, 15)
			if Input.is_action_pressed(up):
				velocity.y = move_toward(velocity.y, -1000, 100)
			
			if not Input.is_action_pressed(special):
				current_state = states.jump
		
		states.fend:
			anim.play("fend")
			if fend_time > 0:
				fend_time -= 1
			else:
				current_state = states.idle
				$Star_split.play()
		
	
	
	
	#Dead
	if position.x > 2500:
		is_colliding_with_the_border = true
	elif position.x < -2500:
		is_colliding_with_the_border = true
	elif position.y > 1800:
		is_colliding_with_the_border = true
	elif position.y < -1800:
		is_colliding_with_the_border = true
	else:
		is_colliding_with_the_border = false
	
	if is_colliding_with_the_border:
		if not dead_sfx_playerd:
			$Dead.play()
			dead_sfx_playerd = true
			dead_delay = 250
		velocity.x = 0
		velocity.y = 0
		current_state = states.damage
	if dead_delay > 0:
		dead_delay -= 1
	else:
		if is_colliding_with_the_border and dead_sfx_playerd:
			if is_player_1:
				Global.Player_1_lives -= 1
				position = Global.Player_1_start_pos
			else:
				Global.Player_2_lives -= 1
				position = Global.Player_2_start_pos
			is_colliding_with_the_border = false
			dead_sfx_playerd = false
	
	if Global.Player_1_Char == "Mario" or Global.Player_2_Char == "Mario":
		if $"../Mario".is_attacking and not current_state == states.damage and not current_state == states.fend:
			current_state = states.damage
			if not $"../Mario".current_state == $"../Mario".states.BLJ_impulse:
				velocity.x = $"../Mario".facing_dir * 1000
				velocity.y = -600
			else:
				if $"../Mario".current_state == $"../Mario".states.slap:
					acumulated_damage += 10
				else:
					velocity.x = $"../Mario".facing_dir * 1000 * -1 + acumulated_damage
					velocity.y = -600 + acumulated_damage
					acumulated_damage = 0
			damage_time = 10
			$"../Mario".is_attacking = false
	
	
	Christendom = clamp(Christendom, 0, 100)
	Christendom += 0.01
	
	if light_time > 0:
		light_time -= 1
		$"../Camera/LIGHT".show()
	else:
		$"../Camera/LIGHT".hide()
	
	
	#update position
	
	if not is_colliding_with_the_border and not current_state == states.up_special_air:
		velocity.y += gravity * delta
	
	move_and_slide()
