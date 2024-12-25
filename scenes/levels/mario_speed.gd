extends Label




func _process(delta: float) -> void:
	if Global.Player_1_Char == "Mario" or Global.Player_2_Char == "Mario":
		text = "SPD %s" % $"../../Mario".velocity.x
