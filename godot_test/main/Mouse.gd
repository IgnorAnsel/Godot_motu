extends Sprite2D
var grid_size = Vector2(24, 24) # 网格大小

func _ready():
	# 确保鼠标始终可见
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _process(delta):
	#var mouse_pos = get_global_mouse_position()
	## 计算对应的网格坐标
	#var grid_x = int(mouse_pos.x / grid_size.x) * grid_size.x
	#var grid_y = int(mouse_pos.y / grid_size.y) * grid_size.y
	## 更新Sprite位置到网格坐标
	#position = Vector2(grid_x, grid_y)
	pass
