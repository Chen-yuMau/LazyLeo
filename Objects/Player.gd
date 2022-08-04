extends KinematicBody2D

onready var screen_shaker = $Camera2D/screen_shaker
var speed = 200
var jump_speed = -400
var grv = 10
var last_dir = 1
var pos
var bps = 2.0
var k = 0
var onbeat = false
var wasonbeat = false
var wasoffbeat = true
var move = 'n'
var offground = 0
func _physics_process(delta):
	if onbeat == true:
		wasoffbeat = false
		wasonbeat = true
	else:
		wasoffbeat = true
		wasonbeat = false
	k+=delta
	if k>(1/bps):
		k = 0
		$AudioStreamPlayer2D.play()
	if k < 0.35*(1/bps) or k > 0.8*(1/bps):
		onbeat = true
	else:	
		onbeat = false
		
	if wasoffbeat and onbeat:
		move = 'n'
	if onbeat and Input.is_action_pressed("ui_left"):
		move = 'l'
	if onbeat and Input.is_action_pressed("ui_right"):
		move = 'r'
	if onbeat and Input.is_action_pressed("ui_up"):
		move = 'u'
	if onbeat and Input.is_action_pressed("ui_down"):
		move = 'd'
	
	if not onbeat and Input.is_action_pressed("ui_left"):
		if k>0.5:
			print("E")
		else:
			print("L")
	if not onbeat and Input.is_action_pressed("ui_right"):
		if k>0.5:
			print("E")
		else:
			print("L")
	if not onbeat and Input.is_action_pressed("ui_up"):
		if k>0.5:
			print("E")
		else:
			print("L")
	if not onbeat and Input.is_action_pressed("ui_down"):
		if k>0.5:
			print("E")
		else:
			print("L")
	
	if wasonbeat and not onbeat:
		if move == 'l':
			self.global_position+=Vector2(-32,0)
		if move == 'r':
			self.global_position+=Vector2(32,0)
		if move == 'u':
			self.global_position+=Vector2(0,-32)
		if move == 'd':
			self.global_position+=Vector2(0,32)
	

