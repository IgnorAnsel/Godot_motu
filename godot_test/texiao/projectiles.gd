extends CharacterBody2D

enum State {
	FLY,
	HIT
}
var state = State.FLY
@export var speed = 500
var direction = Vector2.RIGHT # 默认方向向右
var animation_player: AnimationPlayer
func _ready():
	print("ok")
	animation_player = get_node("AnimationPlayer")
	updata_animation.rpc("fly")
func _physics_process(delta):
	if state == State.FLY:
		var motion = direction.normalized() * speed
		move_and_collide(motion*delta)

func init(pos, dir):
	position = pos
	direction = dir


func _on_area_2d_area_entered(area):
	if state == State.FLY and area: # 确保我们仅在飞行状态且碰撞区域有效时响应
		state = State.HIT
		speed = 0 # 停止移动
		updata_animation.rpc("hit")
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		queue_free()
@rpc("authority","call_local")
func updata_animation(anim_name:String):
	animation_player.play(anim_name)
