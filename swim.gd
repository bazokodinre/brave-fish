extends RigidBody2D

@onready var bs_anim = $Animation
var touched_wall = false
var flipped = false
var swimming_speed = 20

func _on_area_2d_area_entered(area: Area2D) -> void:
	touched_wall = true
	print("fart")

func _on_area_2d_area_exited(area: Area2D) -> void:
	touched_wall = false

func _ready():
	swim_start()

func swim_start():
	self.linear_damp = 0.4
	bs_anim.play("swimstart")
	await get_tree().create_timer(0.4).timeout
	if flipped:
		swimming_speed *= -1
	else:
		swimming_speed = 20
	swim()
	
func swim():
	bs_anim.play("swim")
	self.apply_impulse(Vector2(swimming_speed, 0))
	
func swim_stop():
	bs_anim.play("swimstop")
	self.linear_damp = 2.0
	await bs_anim.animation_finished
	if not touched_wall:
		idle()
	else:
		turn()
	self.linear_damp = 2.0

func idle():
	bs_anim.play("idle")

func turn():
	bs_anim.play("turn")
	await bs_anim.animation_finished
	var scene_children = self.get_children()
	for child in scene_children:
		if child.scale.x != -1:
			child.scale.x = -1
			flipped = true
		else:
			child.scale.x = 1
			flipped = false
	print("hello?? 2")
	swim_start()

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not touched_wall:
		if bs_anim.animation == "swim" and bs_anim.frame == 23:
			self.linear_velocity = Vector2.ZERO
			swim()
			await get_tree().create_timer(0.2).timeout
	else:
		if bs_anim.animation == "swim" and bs_anim.frame == 23:
			swim_stop()
			
