extends Node2D


var Player_1_anim = 0
var Player_2_anim = 1
var Player_1_random = false
var Player_2_random = false
var enable_random = false
var char_count = 1

func _ready() -> void:
	$"Player 1".play("Mario")
	$"Player 2".play("Kirbo")

func _process(delta: float) -> void:
	
	#start_fight
	if Input.is_action_pressed("ui_accept"):
		if not $"Player 1".animation == $"Player 2".animation:
			$BlackBackground.z_index = 999
			get_tree().change_scene_to_file("res://scenes/levels/final_destination.tscn")
		else:
			$Error.play()
		
	if Input.is_action_pressed("ui_accept"):
		if not $"Player 1".animation == $"Player 2".animation:
			$BlackBackground.z_index = 999
		else:
			$Error.play()
	
	
	#chose the players characters
	if $"Player 1".animation == "Mario":
		Global.Player_1_Char = "Mario"
	
	elif $"Player 1".animation == "Kirbo":
		Global.Player_1_Char = "Kirbo"
	
	elif $"Player 1".animation == "Meta_Knight":
		Global.Player_1_Char = "Meta_Knight"
	
	elif $"Player 1".animation == "Link":
		Global.Player_1_Char = "Link"
	
	
	if $"Player 2".animation == "Mario":
		Global.Player_2_Char = "Mario"
	
	elif $"Player 2".animation == "Kirbo":
		Global.Player_2_Char = "Kirbo"
	
	elif $"Player 2".animation == "Meta_Knight":
		Global.Player_2_Char = "Meta_Knight"
	
	elif $"Player 2".animation == "Link":
		Global.Player_2_Char = "Link"
	
	
	#change characters
	
	if Input.is_action_just_pressed("jump"):
		if Player_1_anim < char_count:
			Player_1_anim += 1
		else:
			Player_1_anim = 0
	
	if Input.is_action_just_pressed("attack"):
		if Player_1_anim > 0:
			Player_1_anim -= 1
		else:
			Player_1_anim = char_count
	
	if Input.is_action_just_pressed("special") and enable_random:
		Player_1_random = not Player_1_random
	
	if Input.is_action_just_pressed("jump p2"):
		if Player_2_anim < char_count:
			Player_2_anim += 1
		else:
			Player_2_anim = 0
	
	if Input.is_action_just_pressed("attack p2"):
		if Player_2_anim > 0:
			Player_2_anim -= 1
		else:
			Player_2_anim = char_count
	
	if Input.is_action_just_pressed("special p2") and enable_random:
		Player_2_random = not Player_2_random
	
	
	if Player_1_random:
		$"Player 1".play("random")
	else:
		if Player_1_anim == 0:
			$"Player 1".play("Mario")
	
		if Player_1_anim == 1:
			$"Player 1".play("Kirbo")
	
		if Player_1_anim == 2:
			$"Player 1".play("Meta_Knight")
	
		if Player_1_anim == 3:
			$"Player 1".play("Link")
	
	
	if Player_2_random:
		$"Player 2".play("random")
	else:
		if Player_2_anim == 0:
			$"Player 2".play("Mario")
	
		if Player_2_anim == 1:
			$"Player 2".play("Kirbo")
	
		if Player_2_anim == 2:
			$"Player 2".play("Meta_Knight")
	
		if Player_2_anim == 3:
			$"Player 2".play("Link")



func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://config/config.tscn")
