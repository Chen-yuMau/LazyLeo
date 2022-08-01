extends Sprite

var can_fire = true
var bullet = preload("res://objects/Bullet.tscn")
var state = "shoot"

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	position.x = lerp(position.x, get_parent().position.x, 0.5)
	position.y = lerp(position.y, get_parent().position.y+10, 0.5)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	if Input.is_action_pressed("Fire") and can_fire:
		var bullet_instance = bullet.instance()
		bullet_instance.rotation = rotation+ rand_range(-0.1,0.1)
		bullet_instance.global_position = $Muzzle.global_position
		print(get_parent().get_children())
		get_parent().add_child(bullet_instance)
		get_parent().screen_shaker._shake(0.2,2)
		print(get_parent().get_children())
		can_fire = false
		yield(get_tree().create_timer(0.2), "timeout")
		can_fire = true

func _on_Timer_timeout():
	can_fire = true
