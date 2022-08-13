extends Node2D

onready var camera = $Camera2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var bps = 2.0
var cam_pan_overlap = 3
var cam_slide_width = 1024-cam_pan_overlap*32
var cam_position_number = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func slide_camera(D):
	if D == 'l':
		if cam_position_number !=0:
			cam_position_number-=1
			camera.global_position = camera.global_position+Vector2(-cam_slide_width,0)			
	if D == 'r':
		cam_position_number+=1
		camera.global_position = camera.global_position+Vector2(cam_slide_width,0)
	
