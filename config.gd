extends Node2D


func _ready() -> void:
	if Global.Paralax:
		$paralax.button_pressed = true
	else:
		$paralax.button_pressed = false
	
	if Global.animations:
		$background_movement.button_pressed = true
	else:
		$background_movement.button_pressed = false
	
	if Global.movement:
		$background_animations.button_pressed = true
	else:
		$background_animations.button_pressed = false


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/UI/char_select.tscn")



func _on_paralax_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.Paralax = true
	else:
		Global.Paralax = false




func _on_background_movement_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.movement = true
	else:
		Global.movement = false





func _on_background_animations_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.animations = true
	else:
		Global.animations = false
