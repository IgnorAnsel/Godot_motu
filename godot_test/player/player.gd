class_name Player
extends CharacterBody2D
var hurtdamage = 1
enum State {
	IDEL,
	WALK,
	HURT,
	SWORD_HIT
}
enum WeaponType {
	STAFF,
	SWORD
}
const is_player = true
var weapon_names = ["STAFF", "SWORD"]
var current_weapon = WeaponType.SWORD # 默认选择的武器
signal heal_change
signal hurt_shake_screen
@onready var ft_s = preload("res://UI/float.tscn")
var ft
@export var SPEED = 100.0
@onready var stats = $Stats
@onready var sprite : Sprite2D = $graphics/Sprite2D
@onready var behand_hand : Sprite2D = $graphics/sword_hand
@onready var fireball_scene = preload("res://texiao/fireball.tscn")
var direction_to_mouse
var moveDir: Vector2 = Vector2.ZERO
var animation_player : AnimationPlayer
var Hit_player : AnimationPlayer
var is_attacking = false # 添加一个攻击状态标志
var facing_right = true # 默认朝向右
var can_move = true

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	print("ok")
	sprite.z_index = 1
	behand_hand.z_index = 0
	animation_player = get_node("Player_state")
	Hit_player = get_node("Hit_state")
	# 当动画播放完毕时，重置攻击状态
	#animation_player.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))
#func _on_AnimatedSprite2D_animation_finished(animation_name: String):

func move(delta: float):
	rotate_sword_hand_to_mouse()
	moveDir = Input.get_vector("my_left", "my_right", "my_up", "my_down").normalized()
	if Input.is_action_just_pressed("my_mouse_left"):
		attack()
	if moveDir.length() > 0:
		var velocity = moveDir * SPEED
		move_and_collide(velocity * delta)
		# 更新朝向状态
		if moveDir.x != 0:
			facing_right = moveDir.x > 0
		# 根据朝向翻转sprite
		sprite.flip_h = not facing_right
		behand_hand.flip_h = not facing_right
		if facing_right:
			behand_hand.position.x = 6
		else:
			behand_hand.position.x = -10

func tick_physics(state : State, delta: float):
	if not is_multiplayer_authority():
		return
	if can_move:
		rotate_sword_hand_to_mouse()
		match state:
			State.IDEL:
				move(delta)
			State.WALK:
				move(delta)
func attack():
	match current_weapon:
		WeaponType.STAFF:
			var mouse_position = get_global_mouse_position()
	# 计算从玩家到鼠标位置的方向向量
			direction_to_mouse = (mouse_position - self.position).normalized()
			updadta_hit_animation.rpc("staff_hit")
		WeaponType.SWORD:
			updadta_hit_animation.rpc("sword_hit")
	# 设置为攻击状态
	is_attacking = true
func get_next_state(state : State) -> State:
	if 1: # 如果不是在攻击状态
		if moveDir.length() > 0:
			return State.WALK
		else:
			return State.IDEL
	return state
func translate_state(form: State, to: State):
	match to:
		State.IDEL:
			updata_animation.rpc("idel")
		State.WALK:
			updata_animation.rpc("walk")
		State.HURT:
			updata_animation.rpc("hurt")
			
func _input(event):
	if not is_multiplayer_authority():
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
		current_weapon = (current_weapon + 1) % WeaponType.values().size()
		update_weapon_display.rpc()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
		current_weapon -= 1
		if current_weapon < 0:
			current_weapon = WeaponType.values().size() - 1
		update_weapon_display.rpc()
func launch_fireball():
	if not is_multiplayer_authority():
		return
	var fireball_instance = fireball_scene.instantiate()
	# 设置火球的初始位置，这里可以根据具体需求进行调整
	# 计算火球的初始位置：玩家位置 + 方向向量 * 圆的半径
	print(self.position)
	var fireball_pos = self.position + direction_to_mouse * 30
	var fireball_dir = direction_to_mouse # 火球的移动方向
	fireball_instance.init(fireball_pos, fireball_dir)
	get_parent().add_child(fireball_instance)

func rotate_sword_hand_to_mouse():
	# 获取鼠标的全局位置
	var mouse_position = get_global_mouse_position()
	# 计算从玩家到鼠标的向量
	var vector_to_mouse = mouse_position - global_position
	# 计算旋转角度
	var angle_to_mouse = vector_to_mouse.angle() - 90
	# 设置sword_hand的旋转角度
	if facing_right:
		behand_hand.rotation = angle_to_mouse
	else:
		behand_hand.rotation = angle_to_mouse - 0
	## 根据向量的x值判断玩家和sword_hand的朝向，更新facing_right变量和sprite的翻转状态
	facing_right = vector_to_mouse.x >= 0
	#facing_right = not facing_right
	sprite.flip_h = not facing_right
	behand_hand.flip_h = not facing_right
	if facing_right:
		behand_hand.position.x = 6
	else:
		behand_hand.position.x = -10


func _on_hurtbox_hurt(hitbox):
	can_move = false
	animation_player.stop()
	emit_signal("hurt_shake_screen")
	updata_animation.rpc("hurt")
	hurtdamage = hitbox.get_node("damage").damage
	stats.health -= hurtdamage
	emit_signal("heal_change")
	print(stats.health)
   # 检查是否应该死亡
	piaozi("-"+str(hurtdamage),Color(1,0,0,1))
	if stats.health <= 0:
		updata_animation.rpc("die")
func piaozi(string:String,color:Color):
	ft = ft_s.instantiate()
	ft.text = string
	ft.color = color
	ft.position = self.position
	ft.velocity = Vector2(randf_range(-50,50),-100)
	ft.gravity = Vector2(0,1.5)
	get_parent().get_parent().add_child(ft)

func _on_hit_state_animation_finished(anim_name):
	if anim_name == "staff_hit":
		launch_fireball()

func _on_player_drop_area_entered(area):
	if area.name == "have_shoudao":
		piaozi("+1",Color(1, 1, 0, 1))
func piaozi_chageweapon(string:String,color:Color,font_size:float):
	ft = ft_s.instantiate()
	ft.font_size = font_size
	ft.text = string
	ft.color = color
	ft.position = self.position
	ft.velocity = Vector2(0,-100)
	ft.gravity = Vector2(0,-0.1)
	get_parent().get_parent().add_child(ft)


func _on_player_state_animation_finished(anim_name):
	if not is_multiplayer_authority():
		return
	if anim_name == "hurt":
		can_move = true # 允许移动
	is_attacking = false # 重置攻击状态
	if anim_name == "die":
		queue_free()
	elif anim_name == "staff_hit":
		launch_fireball()
@rpc("authority","call_local")
func update_weapon_display():
	# 假设有两个节点分别代表两种武器
	var staff_hand = $graphics/staff_hand
	var sword_hand = $graphics/sword_hand
	staff_hand.visible = current_weapon == WeaponType.STAFF
	sword_hand.visible = current_weapon == WeaponType.SWORD
	# 更新当前活跃的武器节点
	if current_weapon == WeaponType.STAFF:
		behand_hand = staff_hand
	else:
		behand_hand = sword_hand
	piaozi_chageweapon(str(weapon_names[current_weapon]),Color(1,1,1,0.5),0.5)
@rpc("authority","call_local")
func updata_animation(anim_name:String):
	animation_player.play(anim_name)
@rpc("authority","call_local")
func updadta_hit_animation(anim_name:String):
	Hit_player.play(anim_name)
