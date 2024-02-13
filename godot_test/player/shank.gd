extends Node2D

var time = 0.0
var length = 1.0 # 震动持续时间，以秒为单位
var shake_intensity = 10.0 # 震动强度
var camera: Camera2D
var original_camera_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_parent().get_node("Camera2D")
	original_camera_pos = camera.position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time > 0:
		time -= delta
		var offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		camera.position = original_camera_pos + offset
	else:
		camera.position = original_camera_pos
# 调用这个函数来开始震动效果
func start_shake(duration: float, intensity: float):
	time = duration
	shake_intensity = intensity
	original_camera_pos = camera.position # 更新原始摄像机位置以防它已经移动


func _on_player_hurt_shake_screen():
	start_shake(1,10)
