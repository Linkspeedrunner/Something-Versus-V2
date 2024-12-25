extends CharacterBody2D


#main variables
var speed = 600
var jump_speed = 1200
var gravity = 3000
@onready var anim = $Sprite
var basic_attack_toggle = 0
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
var dash_speed = 1500
var coyote_time = 0
var basic_attack_dur = 15
var basic_attack_time = basic_attack_dur
var up_attack_dur = 15
var up_attack_time = up_attack_dur
var down_attack_dur = 35
var down_attack_time = down_attack_dur
var dash_attack_dur = 34
var dash_attack_time = dash_attack_dur
var is_attacking = false
var fend_dur = 25
var fend_time = fend_dur
var is_fending = false
var toggle_jump = false
var slap_dur = 35
var slap_time = slap_dur
var jump_attack_dur = 15
var jump_attack_time = jump_attack_dur
var can_jump_attack = true
var yahoo_frame = 0
var down_jump_time = 0
var direction = 0
var facing_dir = 0
var is_colliding_with_the_border = false
var dead_sfx_playerd = false
var dead_delay = 0
var colliding_with_other_player = false
var damage_time = 0
var acumulated_speed = 0
var teleporting = false
var slap_spam_time = 0


enum states {
	idle,
	run,
	jump,
	basic_attack,
	up_attack,
	down_attack,
	dash_attack,
	fend,
	slap,
	jump_attack,
	down_attack_jump,
	BLJ,
	damage,
	BLJ_impulse,
}

var current_state : states = states.idle

func _ready() -> void:
	if Global.Player_1_Char == "Mario" or Global.Player_2_Char == "Mario":
		if Global.Player_1_Char == "Mario":
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
		$back.scale.x *= -1
		$up.scale.x *= -1
		$down.scale.x *= -1
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
	
	#the large states part >:(
	
	match current_state:
		states.idle:
			velocity.x = move_toward(velocity.x, 0, 90)
			
			if acumulated_speed < 10000:
				anim.play("idle")
			else:
				anim.play("idle_speed")
			if Input.is_action_pressed(move):
				current_state = states.run
			
			if Input.is_action_just_pressed(jump):
				current_state = states.jump
				velocity.y = -jump_speed
				if not toggle_jump:
					$"Retro Jump".play()
				else:
					$"Retro Jump 2".play()
				toggle_jump = not toggle_jump
			
			if Input.is_action_just_pressed(attack):
				if acumulated_speed < 10000:
					if Input.is_action_pressed(up):
						current_state = states.up_attack
						up_attack_time = up_attack_dur
						if randi_range(1,2) == 1:
							$"Punch 1".play()
						else:
							if randi_range(1,2) == 1:
								$"Punch 2".play()
							else:
								$"Punch 3".play()
					elif Input.is_action_pressed(down):
						current_state = states.down_attack
						down_attack_time = down_attack_dur
					else:
						current_state = states.basic_attack
						basic_attack_time = basic_attack_dur
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
					if randi_range(1,2) == 1:
						$"Punch 1".play()
					else:
						if randi_range(1,2) == 1:
							$"Punch 2".play()
						else:
							$"Punch 3".play()
			
			if not is_on_floor():
				if coyote_time > 8:
					current_state = states.jump
				coyote_time += 1
			else:
				coyote_time = 0
			
			if Input.is_action_just_pressed(fend):
				current_state = states.fend
				fend_time = fend_dur
				$Fend.play()
			
			if Input.is_action_just_pressed(special) and not Input.is_action_pressed(down):
				current_state = states.slap
				$"Punch 1".play()
				slap_time =  slap_dur
			
			if Input.is_action_pressed(special) and Input.is_action_pressed(down):
				current_state = states.BLJ
			
		states.run:
			if acumulated_speed < 1000:
				velocity.x = move_toward(velocity.x, direction * speed, 90)
			else:
				velocity.x = direction * speed
			anim.play("run")
			if not Input.is_action_pressed(move):
				current_state = states.idle
			if Input.is_action_just_pressed(jump):
				current_state = states.jump
				velocity.y = -jump_speed
				if not toggle_jump:
					$"Retro Jump".play()
				else:
					$"Retro Jump 2".play()
				toggle_jump = not toggle_jump
			
			if Input.is_action_just_pressed(attack):
				if acumulated_speed < 10000:
					current_state = states.dash_attack
					velocity.x = facing_dir * dash_speed
					dash_attack_time = dash_attack_dur
					velocity.y = -500
					$"Ho hoo".play()
				else:
					if Input.is_action_just_pressed(attack):
						current_state = states.basic_attack
						basic_attack_time = basic_attack_dur
						if randi_range(1,2) == 1:
							$"Punch 1".play()
						else:
							if randi_range(1,2) == 1:
								$"Punch 2".play()
							else:
								$"Punch 3".play()
			
			if not is_on_floor():
				if coyote_time > 8:
					current_state = states.jump
				coyote_time += 1
			else:
				coyote_time = 0
			
			if Input.is_action_just_pressed(special) and not Input.is_action_pressed(down):
				current_state = states.slap
				$"Punch 1".play()
				slap_time =  slap_dur
			
			if Input.is_action_pressed(special) and Input.is_action_pressed(down):
				current_state = states.BLJ
			
			if Input.is_action_just_pressed(fend):
				current_state = states.fend
				fend_time = fend_dur
				$Fend.play()
			
		states.jump:
			velocity.x = move_toward(velocity.x, direction * speed, 25)
			anim.play("jump")
			if is_on_floor():
				if Input.is_action_pressed(move):
					current_state = states.run
				else:
					current_state = states.idle
			if Input.is_action_just_released(jump) and not is_on_floor() and velocity.y < 0:
				velocity.y *= 0.4
			
			if Input.is_action_just_pressed(attack):
				if not Input.is_action_pressed(down):
					if not Input.is_action_pressed(up):
						if not Input.is_action_pressed(move):
							current_state = states.basic_attack
							basic_attack_time = basic_attack_dur
							if randi_range(1,2) == 1:
								$"Punch 1".play()
							else:
								if randi_range(1,2) == 1:
									$"Punch 2".play()
								else:
									$"Punch 3".play()
						else:
							if acumulated_speed < 10000:
								current_state = states.dash_attack
								velocity.x = facing_dir * dash_speed
								dash_attack_time = dash_attack_dur
								velocity.y = -500
								$"Ho hoo".play()
							else:
								current_state = states.basic_attack
								basic_attack_time = basic_attack_dur
								if randi_range(1,2) == 1:
									$"Punch 1".play()
								else:
									if randi_range(1,2) == 1:
										$"Punch 2".play()
									else:
										$"Punch 3".play()
					else:
						if (can_jump_attack or acumulated_speed > 10000):
							current_state = states.jump_attack
							if randi_range(1,2) == 1:
								$"Punch 1".play()
							else:
								if randi_range(1,2) == 1:
									$"Punch 2".play()
								else:
									$"Punch 3".play()
							$Hoo.play()
							jump_attack_time = jump_attack_dur
							velocity.y = -1200
							can_jump_attack = false
				else:
					current_state = states.down_attack_jump
					$"Punch 1".play()
					velocity.y = -1500
			
			
			if Input.is_action_just_pressed(special):
				current_state = states.slap
				$"Punch 1".play()
				slap_time =  slap_dur
			
			
			
		states.basic_attack:
			velocity.y = -10
			gravity = 0
			
			if acumulated_speed < 10000:
				if is_on_floor():
					velocity.x = move_toward(velocity.x, direction * 50, 90)
				else:
					velocity.x = move_toward(velocity.x, direction * 50, 25)
			else:
				if is_on_floor():
					velocity.x = move_toward(velocity.x, direction * 100, 90)
				else:
					velocity.x = move_toward(velocity.x, direction * 100, 25)
			
			if basic_attack_toggle == 0:
				anim.play("punch 1")
			elif basic_attack_toggle == 1:
				anim.play("punch 2")
			else:
				anim.play("kick 1")
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
				if basic_attack_toggle < 2:
					basic_attack_toggle += 1
				else:
					basic_attack_toggle = 0
				gravity = 3000
		states.up_attack:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, direction * 50, 90)
			else:
				velocity.x = move_toward(velocity.x, direction * 50, 25)
			anim.play("up_attack")
			if up_attack_time > 0:
				up_attack_time -= 1
				if $up.is_colliding():
					is_attacking = true
			else:
				is_attacking = false
				current_state = states.idle
		states.down_attack:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, direction * 50, 90)
			else:
				velocity.x = move_toward(velocity.x, direction * 50, 25)
			anim.play("down_attack")
			if down_attack_time > 0:
				down_attack_time -= 1
			else:
				current_state = states.idle
				is_attacking = false
				$Stomp.play()
			if down_attack_time == 5:
				if $down.is_colliding():
					is_attacking = true
		states.dash_attack:
			anim.play("dash_attack")
			if dash_attack_time > 0:
				dash_attack_time -= 1
				if $front.is_colliding():
					is_attacking = true
			else:
				is_attacking = false
				if is_on_floor():
					if Input.is_action_pressed(move):
						current_state = states.run
					else:
						current_state = states.idle
				else:
					current_state = states.jump
				
			if dash_attack_time == 5:
				$Yah.play()
			
		states.fend:
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, 90)
			else:
				velocity.x = move_toward(velocity.x, 0, 25)
			
			if not teleporting:
				anim.play("fend")
			else:
				anim.play("teleport")
			
			if fend_time > 0:
				fend_time -= 1
				is_fending = true
			else:
				if not is_on_floor():
					current_state = states.jump
				else:
					if Input.is_action_pressed(move):
						current_state = states.run
					else:
						current_state = states.idle 
				is_fending = false
				teleporting = false
			
			if acumulated_speed > 10000:
				if Input.is_action_just_pressed(special):
					position.x += facing_dir * 500
					$Teleport.play()
					teleporting = true
					is_fending = false
					fend_time = 2
					acumulated_speed -= 1000
		
			
		states.slap:
			if slap_spam_time > 0:
				slap_spam_time -= 1
			velocity.x = move_toward(velocity.x, 0, 90)
			velocity.y = 0
			anim.play("slap")
			
			if slap_time > 0:
				slap_time -= 1
			else:
				scale.x = 0.2
				scale.y = 0.2
				if is_on_floor():
					if Input.is_action_pressed(move):
						current_state = states.idle
					else:
						current_state = states.run
				else:
					current_state = states.jump
				if slap_spam_time == 0:
					is_attacking = false
			
			if slap_time == 10:
				if acumulated_speed < 1000:
					$Slap.play()
				else:
					if acumulated_speed < 10000:
						$"S L A P".play()
					else:
						$"M E G A    S L A P".play()
					scale.x = 0.2005
					scale.y = 0.2005
				if $front.is_colliding():
					is_attacking = true
				if $up.is_colliding():
					is_attacking = true
				if $down.is_colliding():
					is_attacking = true
			
			if acumulated_speed > 10000:
				if Input.is_action_just_pressed(special):
					current_state = states.slap
					slap_time =  slap_dur
					slap_spam_time = 4
					if $front.is_colliding():
						is_attacking = true
					if $up.is_colliding():
						is_attacking = true
					if $down.is_colliding():
						is_attacking = true
					if acumulated_speed < 1000:
						$Slap.play()
					else:
						if acumulated_speed < 10000:
							$"S L A P".play()
						else:
							$"M E G A    S L A P".play()
			
		states.jump_attack:
			velocity.x = move_toward(velocity.x, direction * 50, 90)
			anim.play("jump_attack")
			if jump_attack_time > 0:
				jump_attack_time -= 1
				if $up.is_colliding():
					is_attacking = true
			else:
				current_state = states.jump
				is_attacking = false
			
		states.down_attack_jump:
			velocity.x = move_toward(velocity.x, direction * 500, 30)
			down_jump_time += 1
			if down_jump_time > 10:
				anim.play("jump_attack_fall")
				velocity.y = move_toward(velocity.y, 1800, 90)
				if $down.is_colliding():
					is_attacking = true
			else:
				anim.play("down_jump_attack_roll")
				velocity.y = move_toward(velocity.y, 0, 50)
				
			if is_on_floor():
				current_state = states.idle
				$Stomp_strong.play()
				is_attacking = false
			
		states.BLJ:
			if velocity.y == 0:
				velocity.x = move_toward(velocity.x, -100 * direction, 90)
			if velocity.x == 0:
				velocity.y = move_toward(velocity.y, -100 * Input.get_axis(up, down), 90)
			anim.play("BLJ")
			acumulated_speed += 10
			if not Input.is_action_pressed(special):
				if is_on_floor():
					current_state = states.idle
				else:
					current_state = states.jump
			if yahoo_frame == 0:
				$Yahoo.play()
			
			if Input.is_action_just_pressed(jump):
				velocity.x = -acumulated_speed * facing_dir
				current_state = states.BLJ_impulse
			
			if yahoo_frame < 2:
				yahoo_frame += 1
			else:
				yahoo_frame = 0
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
		states.BLJ_impulse:
			acumulated_speed = 0
			if $back.is_colliding():
				is_attacking = true
			anim.play("BLJ_impulse")
			if is_on_floor():
				current_state = states.idle
				is_attacking = false
			velocity.x = move_toward(velocity.x, 0, 5)
			if velocity.x == 0:
				current_state = states.jump
				is_attacking = false
	
	
	
	#misc var updates
	if is_on_floor():
		can_jump_attack = true
		down_jump_time = 0
	
	if acumulated_speed > 0 and not current_state == states.BLJ:
		acumulated_speed -= 1
	
	if acumulated_speed > 1000:
		speed = 1500
	else:
		speed = 1000
	
	
	
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
	
	#take damage
	
	if Global.Player_1_Char == "Kirbo" or Global.Player_2_Char == "Kirbo":
		if $"../Kirbo".is_attacking and not current_state == states.damage and not current_state == states.fend:
			current_state = states.damage
			velocity.x = $"../Kirbo".facing_dir * 1000
			velocity.y = -600
			damage_time = 10
			$"../Kirbo".is_attacking = false
	
	
	#update position
	
	if not current_state == states.slap and not current_state == states.BLJ and not current_state == states.down_attack_jump and not is_colliding_with_the_border:
		velocity.y += gravity * delta
	
	move_and_slide()
	
