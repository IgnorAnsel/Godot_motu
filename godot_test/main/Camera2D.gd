extends Camera2D

# 设置缩放的速度
var zoom_speed = 0.1
# 设置最大和最小缩放级别
var max_zoom = Vector2(3, 3)
var min_zoom = Vector2(0.5, 0.5)
func _enter_tree():
	set_multiplayer_authority(name.to_int())
func _ready():
	# 确保摄像机以当前的缩放级别开始
	if not is_multiplayer_authority():
		return
	zoom = Vector2(1.5, 1.5)
func _input(event):
	if not is_multiplayer_authority():
		return
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("zoom_in") and zoom.x > min_zoom.x and zoom.y > min_zoom.y:
			zoom -= Vector2(zoom_speed, zoom_speed)
		elif Input.is_action_just_pressed("zoom_out") and zoom.x < max_zoom.x and zoom.y < max_zoom.y:
			zoom += Vector2(zoom_speed, zoom_speed)
