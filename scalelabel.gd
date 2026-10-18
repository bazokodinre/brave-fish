extends Label

@onready var bs = $"../fish/BlueSubmariner/fishbody"

func _process(delta: float) -> void:
	self.text = str(bs.scale)
