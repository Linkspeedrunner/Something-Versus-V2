extends Node2D

var Winner_anouncement = false
var winner_anouncement_delay = 0
var game_player = false
var pause = false

func _ready() -> void:
	if Global.Player_1_Char == "Mario":
		$Camera/Mario_speed_1.show()
		$Camera/Acumulated_SPD_1.show()
	else:
		$Camera/Mario_speed_1.hide()
		$Camera/Acumulated_SPD_1.hide()
	
	if Global.Player_2_Char == "Mario":
		$Camera/Mario_speed_2.show()
		$Camera/Acumulated_SPD_2.show()
	else:
		$Camera/Mario_speed_2.hide()
		$Camera/Acumulated_SPD_2.hide()
	
	
	if Global.Player_1_Char == "Kirbo":
		$Camera/Kirbo_bars_size/Christendom_1.show()
	else:
		$Camera/Kirbo_bars_size/Christendom_1.hide()
	
	if Global.Player_2_Char == "Kirbo":
		$Camera/Kirbo_bars_size/Christendom_2.show()
	else:
		$Camera/Kirbo_bars_size/Christendom_2.hide()


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/UI/char_select.tscn")
		Global.Player_1_lives = 3
		Global.Player_2_lives = 3
	
	
	
	
	$"Floor/Black Hole".rotate(30000)
	$"Background/Layer 2/Sprite".play("default")
	$"Background/Layer 4/Sprite".play("default")
	var _fix_delta = delta
	
	if Global.Player_1_lives == 0 or Global.Player_2_lives == 0:
		if not game_player:
			$"G A M E".play()
			game_player = true
			winner_anouncement_delay = 100
			$"Background Music".stop()
		
		if winner_anouncement_delay > 0:
			winner_anouncement_delay -= 1
		else:
			$"Camera/Winner anouncement".position.x += 1
			if Global.Player_2_lives == 0:
				if Global.Player_1_Char == "Mario":
					$"Camera/Speedrunner Mario".position.x += 1
				elif Global.Player_1_Char == "Kirbo":
					$Camera/Kirbo.position.x += 1
			else:
				if Global.Player_2_Char == "Mario":
					$"Camera/Speedrunner Mario".position.x += 1
				elif Global.Player_2_Char == "Kirbo":
					$Camera/Kirbo.position.x += 1
			get_tree().change_scene_to_file("res://scenes/UI/char_select.tscn")
			Global.Player_1_lives = 3
			Global.Player_2_lives = 3
			
		if winner_anouncement_delay < 70 and winner_anouncement_delay > 60:
			$"Camera/Winner anouncement".position.x += 250
		
		if winner_anouncement_delay < 30 and winner_anouncement_delay > 20:
			if Global.Player_2_lives == 0:
				if Global.Player_1_Char == "Mario":
					$"Camera/Speedrunner Mario".position.x += 250
				elif Global.Player_1_Char == "Kirbo":
					$Camera/Kirbo.position.x += 250
			else:
				if Global.Player_2_Char == "Mario":
					$"Camera/Speedrunner Mario".position.x += 250
					
				elif Global.Player_2_Char == "Kirbo":
					$Camera/Kirbo.position.x += 250
	
	
	if Global.Player_1_lives == 3:
		$"Camera/Player 1 Lives".play("3")
	if Global.Player_1_lives == 2:
		$"Camera/Player 1 Lives".play("2")
	if Global.Player_1_lives == 1:
		$"Camera/Player 1 Lives".play("1")
	if Global.Player_1_lives == 0:
		$"Camera/Player 1 Lives".play("0")
	
	if Global.Player_2_lives == 3:
		$"Camera/Player 2 Lives".play("3")
	if Global.Player_2_lives == 2:
		$"Camera/Player 2 Lives".play("2")
	if Global.Player_2_lives == 1:
		$"Camera/Player 2 Lives".play("1")
	if Global.Player_2_lives == 0:
		$"Camera/Player 2 Lives".play("0")
