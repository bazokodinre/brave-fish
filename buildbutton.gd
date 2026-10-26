extends Button

var po_scene = preload("res://placeableobject.tscn")
@onready var buildings = $"../buildings"

func _on_pressed() -> void:
	var po_scene_instantiated = po_scene.instantiate()
	buildings.add_child(po_scene_instantiated)
