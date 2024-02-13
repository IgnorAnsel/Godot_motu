extends Node2D
var velocity = Vector2()
var mass = 100.0
var amplitude = 5.0 # 上下移动的振幅
var speed = 2.5 # 上下移动的速度
var tospeed = 100
var initial_position # 初始位置
var anim : AnimationPlayer
var elapsed_time = 0.0
var target_position = null
var areaName
var gravity = Vector2(0,1.5)
# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $AnimationPlayer
	updata_animation.rpc("rotate")
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * randf_range(-10, 10)
	initial_position = position
	position += velocity
func _process(delta):
	elapsed_time += delta  # 累积时间
	if target_position != null:
		target_position = areaName.global_position # 设置目标位置为玩家的位置
		var direction = (target_position - position).normalized()
		position += direction * tospeed * delta
		# 如果有目标位置，则直接向目标移动
	else:
		# 否则，按原来的方式移动
		position.y = initial_position.y + amplitude * sin(speed * elapsed_time)
func _on_area_2d_area_entered(area):
	if area.name == "PlayerDrop":
		areaName = area
		target_position = area.global_position # 设置目标位置为玩家的位置
func _on_timer_timeout():
		queue_free()
func _on_have_shoudao_area_entered(area):
	if area.name == "PlayerDrop":
		$GPUParticles2D.emitting = false
		$Timer.start()
@rpc("authority","call_local")
func updata_animation(anim_name:String):
	anim.play(anim_name)
