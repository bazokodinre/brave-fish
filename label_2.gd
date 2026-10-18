extends Label

func _process(delta: float) -> void:
	self.text = str($"../fish/BlueSubmariner/fishbody".touched_wall)
