extends Node2D

var amplitude = 50.0 # 上下移动的振幅
var speed = 2.0 # 上下移动的速度
var rotation_speed = 1.0 # 旋转速度
var initial_position # 初始位置

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 更新旋转
	rotation += rotation_speed * delta
	
	# 计算上下移动的新位置
	var new_y = initial_position.y + amplitude * sin(speed * delta / 1000.0)
	position.y = new_y
