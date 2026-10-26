extends StaticBody2D

@onready var colrect = $colrect
var placeable = true
var building_scene = preload("res://building.tscn")
@onready var buildings = self.get_parent()
@onready var zcontrol = $"../../zcontrol"
@onready var poarea = $poarea
var in_areas = 0

func _ready() -> void:
	var mouse_position = get_global_mouse_position()
	var tween = create_tween()
	var follow_tween = tween.tween_property(self, "position", mouse_position, 0.01)
	await get_tree().create_timer(0.01).timeout
	if self.position.y < zcontrol.position.y:
		self.z_index = -1
	else:
		self.z_index = 1
	_ready()

func _on_poarea_area_entered(area: Area2D) -> void:
	in_areas += 1
	colrect.color = Color(1.0, 0.0, 0.0, 1.0)
	placeable = false

func _on_poarea_area_exited(area: Area2D) -> void:
	in_areas -= 1
	if in_areas == 0:
		colrect.color = Color(0.376, 0.933, 0.0, 1.0)
		placeable = true

func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and placeable:
		var inst_build = building_scene.instantiate()
		inst_build.position = self.position
		inst_build.z_index = self.z_index
		buildings.add_child(inst_build)
		queue_free()
