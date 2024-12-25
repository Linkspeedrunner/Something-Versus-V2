extends Node2D

func _process(delta: float) -> void:
	if not Global.Paralax:
		$"Layer 1".autoscroll.x = -200
		$"Layer 2".autoscroll.x = -200
		$"Layer 3".autoscroll.x = -200
		$"Layer 4".autoscroll.x = -200
	if not Global.movement:
		$"Layer 1".autoscroll.x = 0
		$"Layer 2".autoscroll.x = 0
		$"Layer 3".autoscroll.x = 0
		$"Layer 4".autoscroll.x = 0
	if not Global.animations:
		$"Layer 2/Sprite".play("static")
		$"Layer 4/Sprite".play("static")
	
	var _fix_delta = delta
