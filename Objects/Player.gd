extends KinematicBody2D

onready var screen_shaker = $Camera2D/screen_shaker
var move = Vector2()
var speed = 200
var jump_speed = -400
var grv = 10
var last_dir = 1

func _physics_process(delta):
	if is_on_floor():
		move.y = 0 
		if move.x != 0:
			$Sprite.play("Run")
		else:
			$Sprite.play("Idle")
	else:
		move.y += grv
		if move.y>11:
			$Sprite.play("Fall")
		if move.y<0:
			$Sprite.play("Jump")
	if is_on_ceiling():
		move.y = 1
		
	if sign(move.x) == (0):
		$Sprite.flip_h= last_dir == (-1)
	elif sign(move.x) == (-1):
		last_dir = -1
		$Sprite.flip_h=true
	else:
		last_dir = 1
		$Sprite.flip_h=false
	
	move.x = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))*speed
	print(move.y)
	if Input.is_action_pressed("ui_up")and is_on_floor():
		move.y = jump_speed
	move_and_slide(move, Vector2.UP)
