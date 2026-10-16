extends Label

@onready var bs = $"../fish/BlueSubmariner"

func _process(delta: float) -> void:
	self.text = str(bs.scale)
