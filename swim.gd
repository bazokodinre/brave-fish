extends Node2D

var minidleduration = 1.96
var maxidleduration = 9.8
var minswimduration = 0.96
var maxswimduration = 4.8
var speed = 4
var swimming = false
var swimstopspeed = 4
var collisioned = false
var toflip = false
@onready var animation = $Animation

func swimtime():
	var swimtime = get_tree().create_timer(randi_range(minswimduration, maxswimduration))
	await swimtime.timeout
	swimming = false

func _ready() -> void:
	swimstopspeed = 4
	var idle = get_tree().create_timer(randi_range(minidleduration, maxidleduration)).timeout
	animation.play("idle")
	await idle
	animation.play("swimstart")
	await get_tree().create_timer(0.46).timeout
	swimming = true
	animation.play("swim")
	swimtime()
	while swimming == true:
		await get_tree().create_timer(0.01).timeout
		self.position.x += speed
	animation.play("swimstop")
	while swimstopspeed >= 0.5:
		self.position.x += swimstopspeed
		await get_tree().create_timer(0.01).timeout
		swimstopspeed -= 0.05
	await animation.animation_finished
	if toflip == true:
		
		animation.flip_h = true
	_ready()

func _on_area_entered(area: Area2D) -> void:
	swimming = false
	toflip = true
