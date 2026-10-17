extends RigidBody2D

@onready var bs_anim = $base_anim
@onready var turn_anim = $turn_anim
@onready var floor = $"../../Area2D/floor"
@onready var top = $"../../Area2D/top"

var touched_wall = false
var flipped = false
var swimming_speed = 20

var min_idle_chance = 1
var max_idle_chance = 10

var min_turn_chance = 1
var max_turn_chance = 10

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area != floor and area != top:
		touched_wall = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area != floor and area != top:
		touched_wall = false
	
func switch():
	if bs_anim.visible:
		bs_anim.visible = false
		turn_anim.visible = true
		turn_anim.play("turn")
	else:
		bs_anim.visible = true
		turn_anim.visible = false

func _ready():
	swim_start()

func swim_start():
	self.linear_damp = 0.4
	bs_anim.play("swimstart")
	await get_tree().create_timer(0.4).timeout
	
	## handles reverse swimming, removes wall touch to prevent bugs
	if flipped:
		swimming_speed = -20
	else:
		swimming_speed = 20
	if touched_wall:
		touched_wall = false
	
	swim()
	
func swim():
	bs_anim.play("swim")
	var y_impulse = 0
	var roll_direction = randi_range(1, 3)
	match roll_direction:
		1:
			y_impulse = 0
		2:
			y_impulse = 3
		3:
			y_impulse = -3
	floor.area_entered.connect(
		func(area):
			y_impulse = -3
	)
	top.area_entered.connect(
		func(area):
			y_impulse = 3
	)
	self.apply_impulse(Vector2(swimming_speed, y_impulse))
	await bs_anim.animation_finished
	var roll_idle = randi_range(min_idle_chance, max_turn_chance)
	if touched_wall:
		swim_stop()
	elif roll_idle == 10:
		swim_stop()
	else:
		self.linear_velocity = Vector2.ZERO
		swim()
	
func swim_stop():
	bs_anim.play("swimstop")
	self.linear_damp = 2.0
	await bs_anim.animation_finished
	if not touched_wall:
		idle()
	else:
		turn()

func idle():
	bs_anim.play("idle")
	await bs_anim.animation_finished
	var roll_turn = randi_range(min_turn_chance, max_turn_chance)
	var roll_swim = randi_range(1, 3)
	if roll_turn == 10:
		turn()
	elif roll_swim == 3:
		swim_start()
	else:
		idle()

func turn():
	switch()
	await turn_anim.animation_finished
	switch()
	var scene_children = self.get_children()
	for child in scene_children:
		if child.is_class("AnimatedSprite2D"):
			if child.scale.x != -1:
				child.scale.x = -1
				flipped = true
				if child == turn_anim:
					child.position.x += 10
			else:
				child.scale.x = 1
				if child == turn_anim:
					child.position.x -= 10
				flipped = false
	swim_start()
