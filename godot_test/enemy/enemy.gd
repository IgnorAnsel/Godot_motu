class_name Enemy
extends CharacterBody2D
signal heal_change
var hurtdamage = 1
@export var SPEED = 300.0
@export var DetectionArea_rad = 100.0
@onready var stats = $Stats
@onready var sprite: Sprite2D = $graphics/Sprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var area : CollisionShape2D = $DetectionArea/CollisionShape2D
@onready var detection_radius_timer: Timer = $DetectionRadiusTimer
@export var coin_1 = 70.0
@export var coin_2 = 20.0
@export var coin_3 = 10.0
@export var coin_4 = 0.0
@export var coin_5 = 0.0
@export var coin_6 = 0.0
@export var coin_7 = 0.0
@export var coin_8 = 0.0
@export var coin_9 = 0.0
@export var coin_10 = 0.0
var player_id = 1
@onready var ft_s = preload("res://UI/float.tscn")
var ft
const is_player = false
var coin_scene = preload("res://Dropped objects/gold_coin.tscn")
var moveDir: Vector2 = Vector2.ZERO
var animation_player: AnimationPlayer
var is_attacking = false # 添加一个攻击状态标志
var facing_right = true # 默认朝向右
var player_detected = false # 检测到玩家标志
var player: Player
var can_move = true
var Players
func _ready():
	area.shape.radius = DetectionArea_rad
	Players = get_tree().get_root().get_node("main").get_node("Players")
	animation_player = get_node("AnimationPlayer")
	# 当动画播放完毕时，重置攻击状态
	animation_player.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
	detection_area.connect("body_entered", Callable(self, "_on_Body_entered"))
	detection_area.connect("body_exited", Callable(self, "_on_Body_exited"))

func _on_AnimatedSprite2D_animation_finished(animation_name: String):
	if animation_name == "hurt":
		can_move = true # 允许移动
	is_attacking = false # 重置攻击状态
	if animation_name == "die":
		generate_coin()
		print("over")
		queue_free()

func _on_Body_entered(body):
	if body.is_player == true:
		player_id = str(body.name)
		player = Players.get_node(player_id)
		player_detected = true

func _on_Body_exited(body):
	if body == player:
		player_detected = false

func hand():
	if is_attacking or !player_detected:
		updata_animation("idel")  # 确保这里是正确的动画名称
	if player_detected and not is_attacking:
		var player_position = player.global_position
		moveDir = (player_position - global_position).normalized()
		if moveDir.x != 0:
			facing_right = moveDir.x > 0
		sprite.flip_h = not facing_right
		if animation_player.current_animation != "hurt":
			updata_animation("walk")
	elif not player_detected and animation_player.current_animation != "hurt":
		updata_animation("idel")  # 确保这里是正确的动画名称
func _physics_process(delta):
	if can_move:
		if player_detected:
			velocity = moveDir * SPEED
			move_and_slide()
		hand()
		
func _on_hurtbox_hurt(hitbox: Hitbox):
	can_move = false
	# 假设hitbox或者其他方式可以获取到攻击者的引用
	var attacker_position = hitbox.global_position # 或者使用玩家的位置，如果hitbox不携带这个信息

	# 计算攻击者方向
	var direction_to_attacker = (attacker_position - global_position).normalized()

	# 确定后退方向（相反方向）
	var knockback_direction = direction_to_attacker * -1
	var knockback_distance = 25.0 # 后退的距离，根据需要调整

	# 计算后退向量
	var knockback_vector = knockback_direction * knockback_distance

	# 应用后退效果
	move_and_collide(knockback_vector)
	# 播放受伤动画
	sprite.flip_h = knockback_direction.x > 0
	if animation_player.current_animation != "hurt":
		updata_animation("hurt")
		is_attacking = false # 确保在受伤时重置攻击状态
		print("Enemy hurt animation played.")
	hurtdamage = hitbox.get_child(0).damage
	stats.health -= hurtdamage
	emit_signal("heal_change")
	print(stats.health)
   # 检查是否应该死亡
	piaozi("-"+str(hurtdamage),Color(1,0,0,1))
	if stats.health <= 0:
		updata_animation("die")
	else:
		detection_radius_timer.start(5)
		area.shape.radius = DetectionArea_rad * 10



func _on_detection_radius_timer_timeout():
	DetectionArea_rad /= 10	
	area.shape.radius = DetectionArea_rad

func generate_coin():
	var coin_probs = [coin_1, coin_2, coin_3, coin_4, coin_5, coin_6, coin_7, coin_8, coin_9, coin_10]
	# 按照概率生成金币
	for i in range(coin_probs.size()):
		var prob = coin_probs[i]
		if randf() * 100.0 <= prob:
			# 概率满足，生成对应数量的金币
			for j in range(i + 1):  # 生成数量基于概率项的索引+1
				spawn_coin()
			break
func spawn_coin():
	var coin = coin_scene.instantiate()
	coin.position = position + Vector2(randf_range(-5, 5), randf_range(-5, 5))  # 随机位置
	get_parent().add_child(coin)
func piaozi(string:String,color:Color):
	ft = ft_s.instantiate()
	ft.text = string
	ft.color = color
	ft.position = self.position
	ft.velocity = Vector2(randf_range(-50,50),-100)
	ft.gravity = Vector2(0,1.5)
	get_parent().add_child(ft)
#@rpc("authority","call_local")
func updata_animation(anim_name:String):
	animation_player.play(anim_name)
