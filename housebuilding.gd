extends StaticBody2D
@onready var building_texture = $buildingtexture
var highlight_shader = preload("res://Shaders/outline2D_outer.gdshader")
@onready var click_area = $clickarea

func _ready() -> void:
	self.input_pickable = true

func _on_mouse_entered() -> void:
	building_texture.material = ShaderMaterial.new()
	building_texture.material.shader = highlight_shader

func _on_mouse_exited() -> void:
	building_texture.material = null
