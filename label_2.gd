extends Label

func _process(delta: float) -> void:
	self.text = str($"../fish/BlueSubmariner".touched_wall)
