extends KinematicBody2D

onready var screen_shaker = $Camera2D/screen_shaker
var last_dir = 1
var forgiveness_radius = 0.2 #Cannot be more than 0.5
var bps = 2.0
var blt = (1-forgiveness_radius)*(1/bps)
var bht = forgiveness_radius*(1/bps)
var beatlowerthreshold = blt
var beathigherthreshold = bht
var k = 0
var onbeat = false
var wasonbeat = false
var wasoffbeat = true
var move = 'n'
var offground = 0
var detect
var inair = 0
var avdelay = 0
var currentdelay = 0
var delaynum = 10
var delay = []
onready var pos_ontile = get_parent().world_to_map(self.global_position)
onready var under = pos_ontile+Vector2(0,1)
onready var left = pos_ontile+Vector2(-1,0)
onready var right = pos_ontile+Vector2(1,0)

func has_tile(T):
	return(get_parent().get_cellv(T)!=(-1))
func _physics_process(delta):
	$Sprite.flip_h = (last_dir == -1)
	#get surrounding tile coordinates
	pos_ontile = get_parent().world_to_map(self.global_position)
	under = pos_ontile+Vector2(0,1)
	left = pos_ontile+Vector2(-1,0)
	right = pos_ontile+Vector2(1,0)
	
	#determine timing of current frame(in input window or not)
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
	#beatlowerthreshold = (blt)+avdelay
	while beatlowerthreshold > (1/bps):
		beatlowerthreshold-=(1/bps)
	#beathigherthreshold = (bht)+avdelay
	while beathigherthreshold > (1/bps):
		beathigherthreshold-=(1/bps)
	#print((beathigherthreshold+(1/bps)-beatlowerthreshold)-(2*forgiveness_radius*(1/bps)))
	#print("%f/%f/%f/%f"%[beathigherthreshold+(1/bps)-beatlowerthreshold,beathigherthreshold,beatlowerthreshold,avdelay])
	#if (beathigherthreshold+(1/bps)-beatlowerthreshold)!=(2*forgiveness_radius*(1/bps)):
	#	 beatlowerthreshold = blt
	#	 beathigherthreshold = bht
	if k > beatlowerthreshold or k < beathigherthreshold:
		onbeat = true
	else:	
		onbeat = false
	
	#if in input window
	if wasoffbeat and onbeat:
		move = 'n'
	if onbeat and Input.is_action_pressed("ui_left"):
		move = 'l'
		currentdelay = k
	if onbeat and Input.is_action_pressed("ui_right"):
		move = 'r'
		currentdelay = k
	if onbeat and Input.is_action_pressed("ui_up"):
		move = 'u'
		currentdelay = k
	if onbeat and Input.is_action_pressed("ui_down"):
		move = 'd'
		currentdelay = k
	#display input correlation to beat
	if not onbeat and Input.is_action_pressed("ui_left"):
		currentdelay = k
		if k>0.5:
			print("E")
		else:
			print("L")
	if not onbeat and Input.is_action_pressed("ui_right"):
		currentdelay = k
		if k>0.5:
			print("E")
		else:
			print("L")
	if not onbeat and Input.is_action_pressed("ui_up"):
		currentdelay = k
		if k>0.5:
			print("E")
		else:
			print("L")
	if not onbeat and Input.is_action_pressed("ui_down"):
		currentdelay = k
		if k>0.5:
			print("E")
		else:
			print("L")
	
	#immediately after input window over, do input
	#print("%f/%f/%f"%[blt*bps,avdelay*bps,bht*bps])
	#print("hey%f"%[currentdelay])
	if wasonbeat and not onbeat:
		#if currentdelay!=0:
		#	if delay.size()>delaynum:
		#		delay.pop_front()
		#	delay.push_back(currentdelay)
		#	currentdelay = 0
		#	var sum = 0
		#	for n in delay:
		#		sum +=n
		#	avdelay=sum/delay.size()		
			#print(avdelay)
		if move == 'n':
			inair = 3
		if move == 'l' and not has_tile(left):
			self.global_position+=Vector2(-32,0)
			under+=Vector2(-1,0)
			last_dir =  -1
			if not has_tile(under) and inair<2:
				inair = 2
		if move == 'r'and not has_tile(right):
			self.global_position+=Vector2(32,0)
			under+=Vector2(1,0)
			last_dir =  1
			if not has_tile(under) and inair<2:
				inair = 2
		if move == 'u' and inair<3:
			self.global_position+=Vector2(0,-32)
			under+=Vector2(0,-1)
		if move == 'd'and not has_tile(under):
			self.global_position+=Vector2(0,32)
			under+=Vector2(0,1)
			
		if not has_tile(under):
			inair+=1
		else:
			inair = 0
		if inair>3:
			self.global_position+=Vector2(0,32)
		var campos = get_parent().get_parent().cam_position_number
		var campano = get_parent().get_parent().cam_pan_overlap
		var camslidew = get_parent().get_parent().cam_slide_width
		if self.global_position.x<campos*camslidew+(campano-1)*32:
			if last_dir == -1:
				get_parent().get_parent().slide_camera('l')
		if (campos+1)*camslidew+32<self.global_position.x :
			if last_dir == 1:
				get_parent().get_parent().slide_camera('r')
